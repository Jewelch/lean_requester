enum RestfullMethods {
  get("GET"),
  post("POST"),
  put("PUT"),
  delete("DELETE"),
  patch("PATCH"),
  download("DOWNLOAD");

  final String name;

  const RestfullMethods(this.name);
}
