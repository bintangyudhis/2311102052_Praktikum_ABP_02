<x-app-layout>
    <x-slot name="header">
        <div class="flex items-center justify-between gap-4">
            <h2 class="font-semibold text-xl text-gray-800 leading-tight">
                Produk
            </h2>

            <a href="{{ route('products.create') }}">
                <x-primary-button>
                    Tambah Produk
                </x-primary-button>
            </a>
        </div>
    </x-slot>

    <div class="py-12" x-data="{ productName: '', deleteUrl: '' }">
        <div class="max-w-7xl mx-auto sm:px-6 lg:px-8 space-y-4">
            @if (session('status'))
                <div class="rounded-md bg-green-50 p-4 text-sm text-green-700">
                    {{ session('status') }}
                </div>
            @endif

            <div class="bg-white overflow-hidden shadow-sm sm:rounded-lg">
                <div class="p-6 text-gray-900 space-y-4">
                    <form method="GET" action="{{ route('products.index') }}"
                        class="flex flex-col sm:flex-row sm:items-end gap-3">
                        <div class="w-full sm:max-w-sm">
                            <x-input-label for="search" value="Cari (SKU / Nama)" />
                            <x-text-input id="search" name="search" type="text" class="mt-1 block w-full"
                                :value="$search" placeholder="Contoh: SKU-12345 atau Kopi" />
                        </div>

                        <div class="flex items-center gap-2">
                            <x-primary-button>
                                Cari
                            </x-primary-button>

                            @if ($search !== '')
                                <a href="{{ route('products.index') }}"
                                    class="text-sm text-gray-600 hover:text-gray-900 underline">
                                    Reset
                                </a>
                            @endif
                        </div>
                    </form>

                    <div class="overflow-x-auto">
                        <table class="min-w-full divide-y divide-gray-200">
                            <thead class="bg-gray-50">
                                <tr>
                                    <th
                                        class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                        SKU</th>
                                    <th
                                        class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                        Nama</th>
                                    <th
                                        class="px-4 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">
                                        Harga</th>
                                    <th
                                        class="px-4 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">
                                        Stok</th>
                                    <th
                                        class="px-4 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">
                                        Aksi</th>
                                </tr>
                            </thead>
                            <tbody class="bg-white divide-y divide-gray-200">
                                @forelse ($products as $product)
                                    <tr>
                                        <td class="px-4 py-3 whitespace-nowrap text-sm text-gray-900">
                                            {{ $product->sku }}</td>
                                        <td class="px-4 py-3 text-sm text-gray-900">
                                            <div class="font-medium">{{ $product->name }}</div>
                                            @if ($product->description)
                                                <div class="text-gray-500 text-xs mt-0.5">{{ $product->description }}
                                                </div>
                                            @endif
                                        </td>
                                        <td class="px-4 py-3 whitespace-nowrap text-sm text-gray-900 text-right">
                                            Rp {{ number_format((float) $product->price, 2, ',', '.') }}
                                        </td>
                                        <td class="px-4 py-3 whitespace-nowrap text-sm text-gray-900 text-right">
                                            {{ $product->stock }}</td>
                                        <td class="px-4 py-3 whitespace-nowrap text-sm text-right">
                                            <div class="flex items-center justify-end gap-2">
                                                <a href="{{ route('products.edit', $product) }}"
                                                    class="text-indigo-600 hover:text-indigo-900 underline">
                                                    Edit
                                                </a>

                                                <button type="button" class="text-red-600 hover:text-red-900 underline"
                                                    @click="productName = @js($product->name); deleteUrl = @js(route('products.destroy', $product)); $dispatch('open-modal', 'confirm-product-deletion')">
                                                    Hapus
                                                </button>
                                            </div>
                                        </td>
                                    </tr>
                                @empty
                                    <tr>
                                        <td colspan="5" class="px-4 py-6 text-center text-sm text-gray-500">
                                            Belum ada produk.
                                        </td>
                                    </tr>
                                @endforelse
                            </tbody>
                        </table>
                    </div>

                    <div>
                        {{ $products->links() }}
                    </div>
                </div>
            </div>
        </div>

        <x-modal name="confirm-product-deletion" :show="false" maxWidth="md" focusable>
            <div class="p-6">
                <h2 class="text-lg font-medium text-gray-900">
                    Hapus Produk
                </h2>

                <p class="mt-1 text-sm text-gray-600">
                    Yakin mau hapus produk <span class="font-semibold" x-text="productName"></span>? Aksi ini tidak bisa
                    dibatalkan.
                </p>

                <div class="mt-6 flex justify-end">
                    <x-secondary-button x-on:click="$dispatch('close-modal', 'confirm-product-deletion')">
                        Batal
                    </x-secondary-button>

                    <form method="POST" x-bind:action="deleteUrl" class="ml-3">
                        @csrf
                        @method('DELETE')

                        <x-danger-button>
                            Hapus
                        </x-danger-button>
                    </form>
                </div>
            </div>
        </x-modal>
    </div>
</x-app-layout>
