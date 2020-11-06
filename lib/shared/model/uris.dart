String fixURI(String uri) {
  return uri.replaceAll('//', '/').replaceAll(':/', '://');
}
