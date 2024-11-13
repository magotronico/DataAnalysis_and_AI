# backend/send_msm/snd_msm.py

import os
from twilio.rest import Client
from dotenv import load_dotenv

# Load environment variables from the .env file
load_dotenv()

# Retrieve credentials and phone number from environment variables
account_sid = os.getenv('TWILIO_ACCOUNT_SID')
auth_token = os.getenv('TWILIO_AUTH_TOKEN')
twilio_phone_number = os.getenv('TWILIO_PHONE_NUMBER')

def send_agreement_message(nombre, amount, fecha, recipient_number):
    client = Client(account_sid, auth_token)

    # Spanish message template
    message_template = (
        f"Estimado/a {nombre},\n\n"
        f"Agradecemos su colaboración con Dimex. A continuación, le compartimos un resumen del acuerdo de hoy. "
        f"Como recordatorio, su próximo pago de ${amount} está programado para el {fecha}.\n\n"
        f"Para cualquier consulta, no dude en comunicarse con nosotros a través del correo unidadespecializada@dimex.mx "
        f"o al teléfono 81 1247 8686.\n\n"
        f"Atentamente,\nEquipo de Atención al Cliente Dimex."
    )

    # Send message
    message = client.messages.create(
        body=message_template,
        from_=twilio_phone_number,
        to=recipient_number
    )

    print(f"Message sent to {nombre}. SID: {message.sid}")

def print_agreement_message(nombre, amount, fecha, recipient_number):
    # Spanish message template
    message_template = (
        f"Estimado/a {nombre},\n\n"
        f"Agradecemos su colaboración con Dimex. A continuación, le compartimos un resumen del acuerdo de hoy. "
        f"Como recordatorio, su próximo pago de ${amount} está programado para el {fecha}.\n\n"
        f"Para cualquier consulta, no dude en comunicarse con nosotros a través del correo unidadespecializada@dimex.mx "
        f"o al teléfono 81 1247 8686.\n\n"
        f"Atentamente,\nEquipo de Atención al Cliente Dimex."
    )

    print(f"Message to {recipient_number}:\n{message_template}")

def send_hello():
    print("Hello from Twilio!")

if __name__ == "__main__":
    send_hello()