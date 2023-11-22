// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_controller.dart';

// **************************************************************************
// ShelfRouterGenerator
// **************************************************************************

Router _$NoteControllerRouter(NoteController service) {
  final router = Router();
  router.add(
    'POST',
    r'/register',
    service.saveNote,
  );
  router.add(
    'GET',
    r'/<code>',
    service.findById,
  );
  router.add(
    'GET',
    r'/',
    service.findAllNotes,
  );
  router.add(
    'DELETE',
    r'/<code>',
    service.deleteNote,
  );
  router.add(
    'PUT',
    r'/<code>',
    service.updateNote,
  );
  router.add(
    'GET',
    r'/findAllNotesByUser/<code>',
    service.findAllNotesByUser,
  );
  router.add(
    'GET',
    r'/findAllNotesByBook/<code>',
    service.findAllNotesByBook,
  );
  return router;
}
