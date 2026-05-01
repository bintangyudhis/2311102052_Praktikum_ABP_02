<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        User::updateOrCreate(
            ['email' => 'cokomi@example.com'],
            [
                'name' => 'Pak Cokomi',
                'email_verified_at' => now(),
                'password' => Hash::make('password'),
            ]
        );

        $this->call([
            ProductSeeder::class,
        ]);
    }
}
