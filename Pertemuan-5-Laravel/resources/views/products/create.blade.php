<x-app-layout>
    <x-slot name="header">
        <div class="flex items-center justify-between gap-4">
            <h2 class="font-semibold text-xl text-gray-800 leading-tight">
                Tambah Produk
            </h2>

            <a href="{{ route('products.index') }}" class="text-sm text-gray-600 hover:text-gray-900 underline">
                Kembali
            </a>
        </div>
    </x-slot>

    <div class="py-12">
        <div class="max-w-3xl mx-auto sm:px-6 lg:px-8">
            <div class="bg-white overflow-hidden shadow-sm sm:rounded-lg">
                <div class="p-6 text-gray-900">
                    <form method="POST" action="{{ route('products.store') }}" class="space-y-6">
                        @csrf

                        @include('products._form')

                        <div class="flex items-center justify-end gap-3">
                            <a href="{{ route('products.index') }}"
                                class="text-sm text-gray-600 hover:text-gray-900 underline">
                                Batal
                            </a>

                            <x-primary-button>
                                Simpan
                            </x-primary-button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</x-app-layout>
