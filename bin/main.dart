import 'dart:async';
import 'dart:io';

import 'package:PoolCalGenerator/pdfDownloader.dart' as pdfDownloader;
import 'package:PoolCalGenerator/pdfChecker.dart' as pdfChecker;
import 'package:PoolCalGenerator/pdfConverter.dart' as pdfConverter;
import 'package:PoolCalGenerator/xlsxParser.dart' as xlsxParser;
import 'package:PoolCalGenerator/iCalGenerator.dart' as iCalGenerator;

main(List<String> arguments) async{
  //pdfDownloader.download("newPool.pdf");
  print(await pdfChecker.check("newPool.pdf", "pool.pdf"));
  //Timer.periodic(Duration(days: 1), (Timer t) => checkForNewSchedule());
}

void checkForNewSchedule() async {
  String oldPDFPath = "pool.pdf";
  String pdfPath = "newPool.pdf";
  String xlsxPath = "pool.xlsx";
  String iCalPath = "pool.ics";

  try {
    pdfDownloader.download(pdfPath);
  } catch (exception) {
    print(exception);
    return;
  }

  if (!await pdfChecker.check(pdfPath, oldPDFPath)) {
    File pdf = File(pdfPath);
    pdf.delete();
    return;
  }

  try {
    await pdfConverter.convert(pdfPath, xlsxPath);
    var map = xlsxParser.parse(xlsxPath);
    iCalGenerator.generate(map, iCalPath);
  } catch (exception) {
    print(exception);
  }

  File pdf = File(pdfPath);
  pdf.delete();
  File xlsx = File(xlsxPath);
  xlsx.delete();
}
