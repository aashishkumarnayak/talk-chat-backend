<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use App\Models\Message;

class Category extends Model
{
    use HasFactory;
    protected $fillable = ['name'];

    public function messages()
    {
        return $this->hasMany(Message::class);
    }
}
