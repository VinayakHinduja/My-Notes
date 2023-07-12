class CloudStorageException implements Exception {
  const CloudStorageException();
}

// C in CRUD
class CouldNotCreateNote implements CloudStorageException {}

//R in CRUD
class CouldNotGetAllNotes implements CloudStorageException {}

//U in CRUD
class CouldNotUpdateNote implements CloudStorageException {}

//D in CRUD
class CouldNotDeleteNote implements CloudStorageException {}
