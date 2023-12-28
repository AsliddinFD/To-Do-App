from django.urls import path
from . import views
from rest_framework.authtoken.views import obtain_auth_token


urlpatterns = [
    path('users/create/', views.CreateUser.as_view()),
    path('delete-account/', views.DeleteAccount.as_view(), name='delete-account'),
    path('login/', views.Login.as_view()),
    path('todos/', views.ListUserTodos.as_view()),
    path('todos/create/', views.CreateTodo.as_view()),
    path('todos/<int:pk>/delete/', views.DeleteTodo.as_view(), name='delete-todo'),
    path('todos/<int:pk>/update/', views.UpdateTodo.as_view(), name='update-todo'),

]
