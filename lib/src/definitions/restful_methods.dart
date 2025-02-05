enum RestfulMethods {
  get("GET"),
  post("POST"),
  put("PUT"),
  delete("DELETE"),
  patch("PATCH");

  final String name;

  const RestfulMethods(this.name);
}
