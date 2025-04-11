<?php
$lang = \Lang::getLocale();
$class = $lang == 'ar' ? "ar": "nonar";
?>
<ul>
    @foreach ($ticketConversations as $ticketConversation)
        <?php
        $name = $ticketConversation->first_name ? $ticketConversation->first_name.' '.$ticketConversation->last_name: "System";
        ?>
        <li>
            <div style="margin-top:-2px">{!! trans("lang.posted_by_on", ["user"=> "<strong>".htmlentities($name)."</strong>", "time"=> faveoDate($ticketConversation->created_at)]) !!}
                @if ($ticketConversation->is_internal)
                    ({!! trans("lang.as_internal_note") !!})
                @endif
            </div>
            <div style="background-color: rgba(0,0,0,0.04); padding: 5px;" class="{!! $class !!}">{!! $ticketConversation->formatted_body !!}</div>
            <br>
        </li>
    @endforeach
</ul>
