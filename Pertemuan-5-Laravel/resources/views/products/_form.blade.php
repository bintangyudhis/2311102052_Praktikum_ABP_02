@props([
    'product' => null,
])

<div class="space-y-6">
    <div>
        <x-input-label for="sku" value="SKU" />
        <x-text-input id="sku" name="sku" type="text" class="mt-1 block w-full" :value="old('sku', $product?->sku)" required
            autofocus />
        <x-input-error class="mt-2" :messages="$errors->get('sku')" />
    </div>

    <div>
        <x-input-label for="name" value="Nama Produk" />
        <x-text-input id="name" name="name" type="text" class="mt-1 block w-full" :value="old('name', $product?->name)"
            required />
        <x-input-error class="mt-2" :messages="$errors->get('name')" />
    </div>

    <div>
        <x-input-label for="description" value="Deskripsi" />
        <textarea id="description" name="description"
            class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
            rows="4">{{ old('description', $product?->description) }}</textarea>
        <x-input-error class="mt-2" :messages="$errors->get('description')" />
    </div>

    <div class="grid grid-cols-1 sm:grid-cols-2 gap-6">
        <div>
            <x-input-label for="price" value="Harga" />
            <x-text-input id="price" name="price" type="number" step="0.01" min="0"
                class="mt-1 block w-full" :value="old('price', $product?->price)" required />
            <x-input-error class="mt-2" :messages="$errors->get('price')" />
        </div>

        <div>
            <x-input-label for="stock" value="Stok" />
            <x-text-input id="stock" name="stock" type="number" min="0" class="mt-1 block w-full"
                :value="old('stock', $product?->stock)" required />
            <x-input-error class="mt-2" :messages="$errors->get('stock')" />
        </div>
    </div>
</div>
