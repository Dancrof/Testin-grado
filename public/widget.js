// Check if the device is a mobile device based on the orientation property of the window
let isMobile = window.orientation > -1;

// Access the data attribute of the script tag
let scriptTag = document.currentScript;
let chat_url = scriptTag.getAttribute('data-url');
let chat_id = scriptTag.getAttribute('data-id');

// API endpoint URL
const apiUrl = chat_url+'/chat/api/widgets?id='+chat_id;

// Fetch data using the fetch API
fetch(apiUrl).then(response => {
    if (!response.ok) {
        throw new Error('Network response was not ok');
    }
    return response.json();
}).then(data => {
    // Process the JSON data
    let chat_color = data.data.color_code;
    let chat_height = data.data.height ? data.data.height+'px' : '600px';
    let chat_width = data.data.width ? data.data.width+'px' : '420px';
    let chat_img = data.data.is_grabber && data.data.attach ? data.data.attach.view_url : "" ;

    if(data.data.status) {

        let link = document.createElement('link');
        link.href = 'https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css';
        link.rel = 'stylesheet';
        document.head.appendChild(link);

        const atGrab = document.createElement("div");
        atGrab.id = "msv-attention-grab",
            atGrab.innerHTML = '<img src='+chat_img+' alt="Chat attention grabber" style="width: 90px; height: 81px;">',
            atGrab.style.cssText = "position: fixed;";


        // Create a new div element and assign it to the chatWidget variable
        const chatWidget = document.createElement("div");
        chatWidget.id = "msv-cb-widget"; // Set the id attribute of the chatWidget div

        chatWidget.innerHTML = '<i class="fas fa-comment-alt" style="font-size: 1.7em;line-height: 66px;color: #fff;"></i>';

        // Check if the device is mobile and set styles accordingly closeBtn and chatWidget
        isMobile
            ? (
                // If the device is mobile, apply specific styles to closeBtn and chatWidget
                chatWidget.style.cssText = "text-align: center; width: 55px; height: 88px; position: fixed; bottom: 1px; right: 0px; background: " + chat_color + ";  background-repeat: no-repeat; background-size: contain; background-position: 0 0; transition: transform 0.2s ease 0s; cursor: pointer; transform-origin: 50% 50%; z-index: 9999;"
            )
            : (
                // If the device is not mobile, apply different styles to closeBtn and chatWidget
                chatWidget.style.cssText = "text-align: center; width: 60px; height: 60px; position: fixed; bottom: 48px; right: 13px; background: " + chat_color + "; background-repeat: no-repeat; background-size: contain; background-position: 0 0; transition: transform 0.2s ease; cursor: pointer; transform-origin: 50% 50%; z-index: 9999999999; border-radius: 50%;"
            );

        // Create a new div element and assign it to the chatbox variable
        const chatbox = document.createElement("div");
        chatbox.id = "msv-chatbox"; // Set the id attribute of the chatbox div
        chatbox.style.cssText = "font-family: Arial, Helvetica, sans-serif; color: white; z-index: 9999999999; display:none; width: "+chat_width+"; height: "+chat_height+"; position: fixed; right: 15px; background: white; border-radius : 0.6rem;"; // Apply CSS styles to the chatbox div

        // Set the selected position
        const selectedPosition = data.data.position ? data.data.position : 'bottom-right';

        // Function to add classes based on the selected position
        function addPositionClasses(position) {
            const iconClasses = {
                'top-left': 'top-left-icon',
                'top-right': 'top-right-icon',
                'center-left': 'center-left-icon',
                'center-right': 'center-right-icon',
                'bottom-left': 'bottom-left-icon',
                'bottom-right': 'bottom-right-icon',
            };

            const boxClasses = {
                'top-left': 'top-left-box',
                'top-right': 'top-right-box',
                'center-left': 'center-left-box',
                'center-right': 'center-right-box',
                'bottom-left': 'bottom-left-box',
                'bottom-right': 'bottom-right-box',
            };

            const grabClasses = {
                'top-left': 'top-left-grab',
                'top-right': 'top-right-grab',
                'center-left': 'center-left-grab',
                'center-right': 'center-right-grab',
                'bottom-left': 'bottom-left-grab',
                'bottom-right': 'bottom-right-grab',
            };

            const iconPosClass = iconClasses[position];
            chatWidget.classList.add(iconPosClass);

            const boxPosClass = boxClasses[position];
            chatbox.classList.add(boxPosClass);

            const grabPosClass = grabClasses[position];
            chatbox.classList.add(grabPosClass);
        }

        // Function to apply inline styles based on the selected position
        function applyPositionStyles(position) {

            const iconStyles = {
                'top-left': { top: '20px', left: '20px' },
                'top-right': { top: '20px', right: '20px' },
                'center-left': { top: '50%', left: '20px', transform: 'translate(0, -50%)' },
                'center-right': { top: '50%', right: '20px', transform: 'translate(0, -50%)' },
                'bottom-left': { bottom: '20px', left: '20px' },
                'bottom-right': { bottom: '20px', right: '24px' }
            };

            const boxStyles = {
                'top-left': { top: '90px', left: '20px' },
                'top-right': { top: '90px', right: '20px' },
                'center-left': { top: '70px', left: '90px' },
                'center-right': { top: '70px', right: '90px' },
                'bottom-left': { bottom: '90px', left: '20px' },
                'bottom-right': { bottom: '90px', right: '24px' }
            };

            const grabStyles = {
                'top-left': { top: '80px', left: '20px' },
                'top-right': { top: '80px', right: '20px' },
                'center-left': { top: '50%', left: '90px', transform: 'translate(0, -50%)', 'z-index': 1 },
                'center-right': { top: '50%', right: '90px', transform: 'translate(0, -50%)', 'z-index': 1 },
                'bottom-left': { bottom: '70px', left: '20px' },
                'bottom-right': { bottom: '70px', right: '24px' }
            };

            const style = iconStyles[position];
            Object.assign(chatWidget.style, style);

            const bstyle = boxStyles[position];
            Object.assign(chatbox.style, bstyle);

            const gstyle = grabStyles[position];
            Object.assign(atGrab.style, gstyle);
        }

        addPositionClasses(selectedPosition);
        applyPositionStyles(selectedPosition);

        // Create a new div element and assign it to the titleBar variable
        let titleBar = document.createElement("div");
        titleBar.id = "msv-title-bar"; // Set the id attribute of the titleBar div
        titleBar.style.cssText = "background-color: #4266b2; color: white;"; // Apply CSS styles to the titleBar div

        // Create a new div element and assign it to the frameBody variable
        let frameBody = document.createElement("div");
        frameBody.id = "msv-frame-body"; // Set the id attribute of the frameBody div
        frameBody.style.cssText = "width: 100%; height: 100%;"; // Apply CSS styles to the frameBody div

        // Create a new iframe element and assign it to the chatFrame variable
        let chatFrame = document.createElement("iframe");
        chatFrame.id = "msv-chat-frame"; // Set the id attribute of the chatFrame iframe
        chatFrame.src = chat_url+"/chat-widget?chat_url=" + encodeURIComponent(chat_url) + '&chat_id=' + encodeURIComponent(chat_id) + '&chat_data=' + encodeURIComponent(JSON.stringify(data.data)); // Set the src attribute of the chatFrame iframe
        chatFrame.setAttribute("frameborder", "none"); // Set the frameborder attribute of the chatFrame iframe
        chatFrame.setAttribute("width", "100%"); // Set the width attribute of the chatFrame iframe
        chatFrame.setAttribute("height", "100%"); // Set the height attribute of the chatFrame iframe
        chatFrame.setAttribute("allow", "geolocation; microphone; camera; midi; vr; accelerometer; gyroscope; payment; ambient-light-sensor"); // Set the allow attribute of the chatFrame iframe
        chatFrame.style.cssText = "border-radius: 10px;"; // Apply CSS styles to the chatFrame iframe

        // Append the chatFrame iframe to the frameBody div
        frameBody.appendChild(chatFrame);

        // Event listener for click on chatWidget div
        chatWidget.addEventListener(
            "click",
            function () {
                chatbox.style.display = chatbox.style.display == 'block' ? "none" : "block"; // Show the chatbox div
                atGrab.style.display = chatbox.style.display == 'block' ? "none" : "block"; // Show the chatbox div
                chatWidget.innerHTML = chatbox.style.display == 'block' ? '<i class="fas fa-times" style="font-size: 2em;line-height: 61px;color: #fff;"></i>' : '<i class="fas fa-comment-alt" style="font-size: 1.7em;line-height: 66px;color: #fff;"></i>'
            },
            false
        );

        // Function to append the chatWidget to the document body and set its initial image
        let appendChatWidget = () => {
            if(chat_img){
                document.body.appendChild(atGrab); // Append chatWidget div to the document body
            }
            document.body.appendChild(chatWidget); // Append chatWidget div to the document body
        };

        // Set a timeout to append the chatWidget and other elements to the document body
        setTimeout(() => {
            appendChatWidget(); // Call the appendChatWidget function
            chatbox.appendChild(titleBar); // Append titleBar div to the chatbox div
            chatbox.appendChild(frameBody); // Append frameBody div to the chatbox div
            document.body.appendChild(chatbox); // Append chatbox div to the document body
        }, 1);
    }
}).catch(error => {

    console.error('Fetch error:', error);
});