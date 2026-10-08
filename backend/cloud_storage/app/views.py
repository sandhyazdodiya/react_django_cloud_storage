import json
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt


def hello(request):
    return JsonResponse({"message": "Hello World"})

@csrf_exempt
def message(request):
    if request.method == "POST":
        data = json.loads(request.body)

        user_type = data.get("userType")
        message = data.get("message")

        return JsonResponse({
            "userType": user_type,
            "message": message,
        })