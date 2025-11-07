const std = @import("std");

const Address = struct {
    street: []const u8,
    city: []const u8,
};

const Person = struct {
    name: []const u8,
    age: u32,
    address: Address,
};

pub fn run() void {
    std.debug.print("\n=== Nested Struct ===\n", .{});

    std.debug.print("\n1. Creating nested struct:\n", .{});
    const person = Person{
        .name = "Alice",
        .age = 30,
        .address = Address{
            .street = "123 Main St",
            .city = "Springfield",
        },
    };

    std.debug.print("Person {{\n", .{});
    std.debug.print("  name: {s}\n", .{person.name});
    std.debug.print("  age: {}\n", .{person.age});
    std.debug.print("  address: Address {{\n", .{});
    std.debug.print("    street: {s}\n", .{person.address.street});
    std.debug.print("    city: {s}\n", .{person.address.city});
    std.debug.print("  }}\n", .{});
    std.debug.print("}}\n", .{});

    std.debug.print("\n2. Accessing nested fields:\n", .{});
    std.debug.print("{s} lives in {s}\n", .{ person.name, person.address.city });
    std.debug.print("Address: {s}, {s}\n", .{ person.address.street, person.address.city });
}

pub fn runMoreExamples() void {
    std.debug.print("\n=== More Nested Struct Examples ===\n", .{});

    const Company = struct {
        name: []const u8,
        address: Address,
    };

    const Employee = struct {
        name: []const u8,
        age: u32,
        company: Company,
        home_address: Address,

        pub fn printInfo(self: @This()) void {
            std.debug.print("\nEmployee: {s} (age {})\n", .{ self.name, self.age });
            std.debug.print("Company: {s}\n", .{self.company.name});
            std.debug.print("Company Address: {s}, {s}\n", .{ self.company.address.street, self.company.address.city });
            std.debug.print("Home Address: {s}, {s}\n", .{ self.home_address.street, self.home_address.city });
        }
    };

    std.debug.print("\n1. Deeply nested struct:\n", .{});
    const employee = Employee{
        .name = "Bob",
        .age = 35,
        .company = Company{
            .name = "Tech Corp",
            .address = Address{
                .street = "456 Business Ave",
                .city = "Silicon Valley",
            },
        },
        .home_address = Address{
            .street = "789 Home St",
            .city = "San Francisco",
        },
    };

    employee.printInfo();
}

pub fn runWithOptional() void {
    std.debug.print("\n=== Nested Struct with Optional ===\n", .{});

    const ContactInfo = struct {
        email: []const u8,
        phone: ?[]const u8, // Optional phone number
    };

    const User = struct {
        name: []const u8,
        contact: ContactInfo,

        pub fn displayContact(self: @This()) void {
            std.debug.print("Name: {s}\n", .{self.name});
            std.debug.print("Email: {s}\n", .{self.contact.email});
            if (self.contact.phone) |phone| {
                std.debug.print("Phone: {s}\n", .{phone});
            } else {
                std.debug.print("Phone: (not provided)\n", .{});
            }
        }
    };

    std.debug.print("\n1. User with phone number:\n", .{});
    const user1 = User{
        .name = "Carol",
        .contact = ContactInfo{
            .email = "carol@example.com",
            .phone = "555-1234",
        },
    };
    user1.displayContact();

    std.debug.print("\n2. User without phone number:\n", .{});
    const user2 = User{
        .name = "Dave",
        .contact = ContactInfo{
            .email = "dave@example.com",
            .phone = null,
        },
    };
    user2.displayContact();
}
