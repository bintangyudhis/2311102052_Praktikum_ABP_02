<?php

namespace Database\Factories;

use App\Models\Product;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends Factory<Product>
 */
class ProductFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'sku' => $this->faker->unique()->bothify('SKU-#####'),
            'name' => $this->faker->words(3, true),
            'description' => $this->faker->optional(0.7)->sentence(14),
            'price' => $this->faker->randomFloat(2, 1000, 500000),
            'stock' => $this->faker->numberBetween(0, 150),
        ];
    }
}
