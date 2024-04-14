#!/bin/bash

# BACKEND_URL="${backend_nlb}"
# echo '<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< $BACKEND_URL >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'
# Update system packages
sudo apt-get update && sudo apt-get upgrade -y
# Install Nginx
sudo apt install -y nginx
# Start Nginx service
sudo systemctl start nginx
# Enable Nginx to start on boot
sudo systemctl enable nginx
# Create an HTML file using a heredoc

cat << 'EOF' > /var/www/html/index.html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Phonebook</title>
  <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.16/dist/tailwind.min.css" rel="stylesheet">
</head>
<body class="bg-gray-100 font-sans">
  <div class="container mx-auto py-8 flex flex-col items-center">
    <h1 class="text-3xl font-bold mb-4">Phonebook</h1>

    <div class="bg-white shadow-md rounded-md p-6 mb-6 w-2/4">
      <h2 class="text-xl font-bold mb-4">Add New Entry</h2>
      <form id="add-form" class="space-y-4 flex flex-col">
        <div>
          <label for="firstname" class="block mb-1">First Name</label>
          <input type="text" id="firstname" name="firstname" class="border-gray-300 rounded-md shadow-sm w-full text-xl p-2" required>
        </div>
        <div>
          <label for="lastname" class="block font-medium mb-1">Last Name</label>
          <input type="text" id="lastname" name="lastname" class="border-gray-300 rounded-md shadow-sm w-full text-xl p-2" required>
        </div>
        <div>
          <label for="email" class="block font-medium mb-1">Email</label>
          <input type="email" id="email" name="email" class="border-gray-300 rounded-md shadow-sm w-full text-xl p-2" required>
        </div>
        <div>
          <label for="phone" class="block font-medium mb-1">Phone</label>
          <input type="tel" id="phone" name="phone" class="border-gray-300 rounded-md shadow-sm w-full text-xl p-2" required>
        </div>
        <div>
          <label for="address" class="block font-medium mb-1">Address</label>
          <input type="text" id="address" name="address" class="border-gray-300 rounded-md shadow-sm w-full text-xl p-2" required>
        </div>
        <div>
          <label for="city" class="block font-medium mb-1">City</label>
          <input type="text" id="city" name="city" class="border-gray-300 rounded-md shadow-sm w-full text-xl p-2" required>
        </div>
        <div>
          <label for="country" class="block font-medium mb-1">Country</label>
          <input type="text" id="country" name="country" class="border-gray-300 rounded-md shadow-sm w-full text-xl p-2" required>
        </div>
        <button type="submit" class="bg-blue-500 hover:bg-blue-600 text-white font-medium py-2 px-4 rounded-md text-xl p-3">
          Add Entry
        </button>
      </form>
    </div>

    <div class="bg-white shadow-md rounded-md p-6 flex flex-col w-full">
      <h2 class="text-xl font-bold mb-4">Phonebook Entries</h2>
      <table class="w-full border-collapse">
        <thead>
          <tr class="bg-gray-200">
            <th class="py-2 px-4 text-left">First Name</th>
            <th class="py-2 px-4 text-left">Last Name</th>
            <th class="py-2 px-4 text-left">Email</th>
            <th class="py-2 px-4 text-left">Phone</th>
            <th class="py-2 px-4 text-left">Actions</th>
          </tr>
        </thead>
        <tbody id="entries-table">
        </tbody>
      </table>
    </div>
  </div>

  <script>
    const API_URL = '${BACKEND_URL}:5000/phonebook';

    // Add new entry
    const addForm = document.getElementById('add-form');
    addForm.addEventListener('submit', async (event) => {
      event.preventDefault();
      const formData = new FormData(event.target);
      const data = Object.fromEntries(formData.entries());

      try {
        const response = await fetch(API_URL, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json'
          },
          body: JSON.stringify(data)
        });
        const newEntry = await response.json();
        addEntryToTable(newEntry);
        event.target.reset();
      } catch (error) {
        console.error('Error adding entry:', error);
      }
    });

    // Fetch and display all entries
    async function fetchEntries() {
      try {
        const response = await fetch(API_URL);
        const entries = await response.json();
        const entriesTable = document.getElementById('entries-table');
        entriesTable.innerHTML = '';

        entries.forEach(entry => {
          addEntryToTable(entry);
        });
      } catch (error) {
        console.error('Error fetching entries:', error);
      }
    }

    function addEntryToTable(entry) {
      const entriesTable = document.getElementById('entries-table');
      const row = document.createElement('tr');
      row.innerHTML = `
        <td class="py-2 px-4 border-b">${entry.firstname}</td>
        <td class="py-2 px-4 border-b">${entry.lastname}</td>
        <td class="py-2 px-4 border-b">${entry.email}</td>
        <td class="py-2 px-4 border-b">${entry.phone}</td>
        <td class="py-2 px-4 border-b">
          <button class="bg-red-500 hover:bg-red-600 text-white font-medium py-1 px-2 rounded-md">Delete</button>
        </td>
      `;
      entriesTable.appendChild(row);
    }

    fetchEntries();
  </script>
</body>
</html>
EOF
