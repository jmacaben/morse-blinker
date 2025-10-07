import cv2
import time

MORSE_CODE_DICT = {
    '.-': 'A', '-...': 'B', '-.-.': 'C',
    '-..': 'D', '.': 'E', '..-.': 'F',
    '--.': 'G', '....': 'H', '..': 'I',
    '.---': 'J', '-.-': 'K', '.-..': 'L',
    '--': 'M', '-.': 'N', '---': 'O',
    '.--.': 'P', '--.-': 'Q', '.-.': 'R',
    '...': 'S', '-': 'T', '..-': 'U',
    '...-': 'V', '.--': 'W', '-..-': 'X',
    '-.--': 'Y', '--..': 'Z',
    '-----':'0', '.----':'1', '..---':'2',
    '...--':'3', '....-':'4', '.....':'5',
    '-....':'6', '--...':'7', '---..':'8',
    '----.':'9'
}

# Timing constants (following dot length of 250ms)
UNIT = 0.25
DOT = UNIT
DASH = 3*UNIT
SYMBOL_SPACE = UNIT
LETTER_SPACE = 3*UNIT
WORD_SPACE = 7*UNIT
SENTENCE_SPACE = 20*UNIT

cap = cv2.VideoCapture(0)
if not cap.isOpened():
    raise Exception("Camera not found!")

# Start relatively low since LED on FPGA board is pretty dim
THRESHOLD = 100

signal = ""             # Holds sequence of dots and dashes
decoded_message = ""    # Holds final decoded message

# Keep track of how long the LED has been on or off
last_state = 0
last_time = time.time()

last_sentence = ""          # Stores last full sentence for camera overlay
sentence_display_time = 0  
DISPLAY_DURATION = 2        # How long to display full sentence on camera

try:
    while True:
        ret, frame = cap.read()
        if not ret:
            break

        h, w, _ = frame.shape                           # Get frame dimensions
        roi = frame[h//3:2*h//3, w//3:2*w//3]           # Define region of interest (ROI) to analyze instead of whole frame
        gray = cv2.cvtColor(roi, cv2.COLOR_BGR2GRAY)    # Convert ROI to grayscale

        avg_brightness = gray.mean()
        state = 1 if avg_brightness > THRESHOLD else 0  # Determine LED state based on brightness

        # Measure how long the state lasted
        current_time = time.time()
        duration = current_time - last_time

        if state != last_state:
            # Finding if LED was a dot or a dash
            if state == 0: 
                if duration < (DOT + UNIT):
                    signal += "."
                else:
                    signal += "-"
            # Or determine the type of space left (symbol, letter, word, or sentence space)
            else:   
                if duration >= WORD_SPACE - UNIT:       # Word completed
                    if signal:
                        decoded_message += MORSE_CODE_DICT.get(signal, '?')
                        signal = ""
                    decoded_message += " "
                elif duration >= LETTER_SPACE - UNIT:   # Letter completed
                    if signal:
                        decoded_message += MORSE_CODE_DICT.get(signal, '?')
                        signal = ""

            # Reset timers and states
            last_time = current_time
            last_state = state

        elif state == 0 and (time.time() - last_time) >= SENTENCE_SPACE:
            # Decode last letter if any
            if signal:
                decoded_message += MORSE_CODE_DICT.get(signal, '?')
                signal = ""

            # Print full message once
            if decoded_message.strip():
                last_sentence = decoded_message.strip()
                sentence_display_time = time.time()
                print(last_sentence)

            decoded_message = ""    # Reset for next message
            last_time = time.time() # Reset timer 

        # Draw ROI rectangle with color indicating LED detection (Green=ON, Red=OFF)
        color = (0,255,0) if state else (0,0,255) 
        cv2.rectangle(frame, (w//3, h//3), (2*w//3, 2*h//3), color, 2)

        # Draw Morse signal being formed
        cv2.putText(frame, f"Signal: {signal}", (10, 30),
                    cv2.FONT_HERSHEY_SIMPLEX, 0.8, (255,255,255), 2)
        
        if last_sentence and (time.time() - sentence_display_time < DISPLAY_DURATION):
            display_text = last_sentence                                # Show last full sentence temporarily
        else:
            display_text = decoded_message.strip()
            if time.time() - sentence_display_time >= DISPLAY_DURATION:
                last_sentence = ""                                      # Clear last sentence after displaying

        # Write translated message so far
        cv2.putText(frame, f"Decoded: {display_text}", (10, 70),
                    cv2.FONT_HERSHEY_SIMPLEX, 0.8, (0,255,255), 2)

        cv2.imshow("Morse Receiver", frame)

        # Quit if 'q' pressed
        if cv2.waitKey(1) & 0xFF == ord('q'):
            break

except KeyboardInterrupt:
    pass

cap.release()
cv2.destroyAllWindows()