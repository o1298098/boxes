class ExportLinks {
  String applicationRtf;
  String applicationVndOasisOpendocumentText;
  String textHtml;
  String applicationPdf;
  String applicationEpubZip;
  String applicationZip;
  String applicationVndOpenxmlformatsOfficedocumentWordprocessingmlDocument;
  String textPlain;

  ExportLinks({
    this.applicationRtf,
    this.applicationVndOasisOpendocumentText,
    this.textHtml,
    this.applicationPdf,
    this.applicationEpubZip,
    this.applicationZip,
    this.applicationVndOpenxmlformatsOfficedocumentWordprocessingmlDocument,
    this.textPlain,
  });

  factory ExportLinks.fromJson(Map<String, dynamic> json) {
    return ExportLinks(
      applicationRtf: json['application/rtf'] as String,
      applicationVndOasisOpendocumentText:
          json['application/vnd.oasis.opendocument.text'] as String,
      textHtml: json['text/html'] as String,
      applicationPdf: json['application/pdf'] as String,
      applicationEpubZip: json['application/epub+zip'] as String,
      applicationZip: json['application/zip'] as String,
      applicationVndOpenxmlformatsOfficedocumentWordprocessingmlDocument: json[
              'application/vnd.openxmlformats-officedocument.wordprocessingml.document']
          as String,
      textPlain: json['text/plain'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'application/rtf': applicationRtf,
      'application/vnd.oasis.opendocument.text':
          applicationVndOasisOpendocumentText,
      'text/html': textHtml,
      'application/pdf': applicationPdf,
      'application/epub+zip': applicationEpubZip,
      'application/zip': applicationZip,
      'application/vnd.openxmlformats-officedocument.wordprocessingml.document':
          applicationVndOpenxmlformatsOfficedocumentWordprocessingmlDocument,
      'text/plain': textPlain,
    };
  }
}
