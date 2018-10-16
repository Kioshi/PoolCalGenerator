import 'dart:async';
import 'dart:io';

import 'package:PoolCalGenerator/pdfDownloader.dart' as pdfDownloader;
import 'package:PoolCalGenerator/pdfChecker.dart' as pdfChecker;
import 'package:PoolCalGenerator/pdfConverter.dart' as pdfConverter;
import 'package:PoolCalGenerator/xlsxParser.dart' as xlsxParser;
import 'package:PoolCalGenerator/iCalGenerator.dart' as iCalGenerator;

main(List<String> arguments) async{
  //pdfDownloader.download("newPool.pdf");
  checkForNewSchedule();
  //Timer.periodic(Duration(days: 1), (Timer t) => checkForNewSchedule());
}

void checkForNewSchedule() async {
  String oldPDFPath = "pool.pdf";
  String pdfPath = "newPool.pdf";
  String xlsxPath = "pool.xlsx";
  String iCalPath = "pool.ics";

  try {
    await pdfDownloader.download(pdfPath);
  } catch (exception) {
    print(exception);
    return;
  }

  if (await pdfChecker.check(pdfPath, oldPDFPath)) {
    File pdf = File(pdfPath);
    pdf.delete();
    return;
  }

  try {
    await pdfConverter.convert(pdfPath, xlsxPath);
    var map = await xlsxParser.parse(xlsxPath);
    await iCalGenerator.generate(map, iCalPath);
  } catch (exception) {
    print(exception);
  }

  File pdf = File(oldPDFPath);
  if (await pdf.exists())
    pdf.delete();
  File newPdf = File(pdfPath);
  newPdf.rename(oldPDFPath);
  File xlsx = File(xlsxPath);
  xlsx.delete();
}
