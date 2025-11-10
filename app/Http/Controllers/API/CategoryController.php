<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Category;

class CategoryController extends Controller
{
    public function index()
    {
        $categories = Category::all();
        return response()->json(['categories' => $categories]);
    }

    public function store(Request $request)
    
     {
        $category = Category::create($request->all());
         return response()->json(['category' => $category]);
       }

    public function show($id)
    {
        $category = Category::find($id);
        if (!$category) {
            return response()->json(['message' => 'Category not found'], 404);
        }
        return response()->json(['category' => $category]);
    }

   //  public function update(Request $request, $id)
    
   //  {
   //      $category = Category::find($id);
   //      $category->update($request->all());
   //      return response()->json(['category' => $category]);
   //    }

   //  public function destroy($id)
    
   //  {
   //  {
   //      $category = Category::find($id);
   //      $category->delete();
   //      return response()->json(['message' => 'Category deleted successfully']);
   //    }
   //  }
}
