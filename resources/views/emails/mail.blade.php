@if($inlineImages)
    <?php
    foreach ($inlineImages as $inlineImage) {
        // adding urldecode because htmlpurifier encodes src of the image
        $replace = $message->embedData(file_get_contents($inlineImage['path'].DIRECTORY_SEPARATOR.$inlineImage["name"]), $inlineImage['name']);
        $data = str_replace("cid:".$inlineImage["content_id"], $replace, $data);

    }
    ?>
@endif
@if($inlineCID)
<?php
/**
 * Considering the inline images added to content via editors will only be as
 * TinyMCE uploads and will contain the TinyMCE upload links for inline images
 * added from other resources will not be handled from this snippet.
 */
$tinyMCEPattern = '#'.url('/').'/storage/tinymce_attachments/.+?\"#';
preg_match_all($tinyMCEPattern, $data, $matches);

foreach ($matches[0] as $match) {
    $break = explode('tinymce_attachments/', $match);
    $embeded = $message->embed(storage_path('app/public/tinymce_attachments').DIRECTORY_SEPARATOR.urldecode(str_replace('"', '', $break[1])));
    $data = str_replace($match, $embeded.'"', $data);
}
?>
@endif
{!! $data !!}
