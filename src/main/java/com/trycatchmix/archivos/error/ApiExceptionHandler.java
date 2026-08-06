package com.trycatchmix.archivos.error;

import com.trycatchmix.archivos.service.QuestAuthoringService.InvalidDraftException;
import com.trycatchmix.archivos.service.QuestAuthoringService.QuestInUseException;
import com.trycatchmix.archivos.service.QuestAuthoringService.QuestNotFoundException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.util.Map;

/** Convierte las excepciones en JSON {error, message}, que es lo que el
 *  frontend lee (err.error.error / err.error.message). */
@RestControllerAdvice
public class ApiExceptionHandler {

    @ExceptionHandler(ApiException.class)
    public ResponseEntity<Map<String, Object>> handle(ApiException ex) {
        return ResponseEntity.status(ex.getStatus())
                .body(Map.of("error", ex.getCode(), "message", ex.getMessage()));
    }

    /** Borrador inválido: devuelve el informe con errores y avisos. */
    @ExceptionHandler(InvalidDraftException.class)
    public ResponseEntity<Map<String, Object>> handleInvalid(InvalidDraftException ex) {
        return ResponseEntity.unprocessableEntity()
                .body(Map.of("error", "INVALID_DRAFT", "message", ex.getMessage(),
                        "report", ex.getReport()));
    }

    @ExceptionHandler(QuestInUseException.class)
    public ResponseEntity<Map<String, Object>> handleInUse(QuestInUseException ex) {
        return ResponseEntity.status(HttpStatus.CONFLICT)
                .body(Map.of("error", "QUEST_IN_USE", "message", ex.getMessage()));
    }

    @ExceptionHandler(QuestNotFoundException.class)
    public ResponseEntity<Map<String, Object>> handleNotFound(QuestNotFoundException ex) {
        return ResponseEntity.status(HttpStatus.NOT_FOUND)
                .body(Map.of("error", "NOT_FOUND", "message", ex.getMessage()));
    }
}
