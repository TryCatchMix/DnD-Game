package com.trycatchmix.archivos.service;

import com.trycatchmix.archivos.error.ApiException;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.util.Map;
import java.util.UUID;

/**
 * El armario: dónde caen los bytes de los archivos de La Mesa.
 *
 * Van a disco, no a la base de datos, porque son mapas y PDF de varios megas y
 * la BD no es un sistema de ficheros. La ruta se configura con
 * {@code archivos.mesa.dir} (en Docker, móntala como volumen o perderás el
 * material al recrear el contenedor).
 *
 * Regla que no se negocia: el nombre en disco lo generamos nosotros
 * (uuid + extensión sacada del MIME). Nada de lo que manda el navegador toca
 * la ruta, así no hay forma de escaparse del directorio con "../".
 */
@Component
public class MesaStorage {

    /** Lo que aceptamos subir, y con qué extensión se guarda cada cosa. */
    private static final Map<String, String> ADMITIDOS = Map.of(
            "image/jpeg", "jpg",
            "image/png",  "png",
            "image/webp", "webp",
            "image/gif",  "gif",
            "application/pdf", "pdf");

    /** 25 MB por archivo. Un mapa grande cabe; un vídeo no, y así debe ser. */
    public static final long MAX_BYTES = 25L * 1024 * 1024;

    private final Path raiz;

    public MesaStorage(@Value("${archivos.mesa.dir:data/mesa}") String dir) {
        this.raiz = Path.of(dir).toAbsolutePath().normalize();
    }

    /** imagen | pdf, o excepción si el tipo no está admitido. */
    public String kindDe(String mime) {
        String ext = ADMITIDOS.get(mime == null ? "" : mime.toLowerCase());
        if (ext == null) throw ApiException.badRequest(
                "Solo se pueden subir imágenes (JPG, PNG, WEBP, GIF) y PDF.");
        return "pdf".equals(ext) ? "pdf" : "imagen";
    }

    /** Guarda el fichero y devuelve el nombre con el que quedó en disco. */
    public String guardar(MultipartFile file) {
        if (file == null || file.isEmpty())
            throw ApiException.badRequest("No ha llegado ningún archivo.");
        if (file.getSize() > MAX_BYTES)
            throw ApiException.badRequest("El archivo pasa de 25 MB.");

        String ext = ADMITIDOS.get(String.valueOf(file.getContentType()).toLowerCase());
        if (ext == null) throw ApiException.badRequest(
                "Solo se pueden subir imágenes (JPG, PNG, WEBP, GIF) y PDF.");

        String nombre = UUID.randomUUID() + "." + ext;
        try {
            Files.createDirectories(raiz);
            try (var in = file.getInputStream()) {
                Files.copy(in, raiz.resolve(nombre), StandardCopyOption.REPLACE_EXISTING);
            }
        } catch (IOException e) {
            throw new ApiException(org.springframework.http.HttpStatus.INTERNAL_SERVER_ERROR,
                    "STORAGE_ERROR", "No se ha podido guardar el archivo.");
        }
        return nombre;
    }

    public byte[] leer(String storageName) {
        try {
            return Files.readAllBytes(ruta(storageName));
        } catch (IOException e) {
            throw ApiException.notFound("El archivo ya no está en el armario.");
        }
    }

    /** Borrar es best-effort: si el fichero ya no está, la ficha se borra igual. */
    public void borrar(String storageName) {
        try {
            Files.deleteIfExists(ruta(storageName));
        } catch (IOException ignored) {
            // Un huérfano en disco no debe impedir borrar la ficha en la BD.
        }
    }

    /** Resuelve dentro de la raíz y comprueba que no se ha salido de ella. */
    private Path ruta(String storageName) {
        Path p = raiz.resolve(storageName).normalize();
        if (!p.startsWith(raiz)) throw ApiException.badRequest("Ruta de archivo inválida.");
        return p;
    }
}
