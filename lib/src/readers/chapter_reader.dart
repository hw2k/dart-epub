import '../ref_entities/epub_book_ref.dart';
import '../ref_entities/epub_chapter_ref.dart';
import '../ref_entities/epub_text_content_file_ref.dart';

class ChapterReader {
  static List<EpubChapterRef> getChapters(EpubBookRef bookRef) {
    if (bookRef.Schema.Navigation == null) {
      return <EpubChapterRef>[];
    }

    return getChaptersImpl(bookRef);
  }

  static List<EpubChapterRef> getChaptersImpl(EpubBookRef bookRef) {
    var result = <EpubChapterRef>[];

    bookRef.Schema.Package.Spine.Items.forEach((spineItem) {
      String contentFileName;

      contentFileName = bookRef.Schema.Package.Manifest.Items
          .firstWhere((element) => element.Id == spineItem.IdRef).Href;

      EpubTextContentFileRef htmlContentFileRef;

      if (!bookRef.Content.Html.containsKey(contentFileName)) {
        throw Exception(
            "Incorrect EPUB manifest: item with href = \"${contentFileName}\" is missing.");
      }

      htmlContentFileRef = bookRef.Content.Html[contentFileName];

      var chapterRef = EpubChapterRef(htmlContentFileRef)
        ..ContentFileName = contentFileName
        ..SubChapters = [];

      result.add(chapterRef);
    });

    return result;
  }
}
