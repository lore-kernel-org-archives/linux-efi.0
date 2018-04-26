From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1] device property: Get rid of union aliasing
Date: Thu, 26 Apr 2018 13:23:56 +0300
Message-ID: <20180426102356.77394-1-andriy.shevchenko@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-efi@vger.kernel.org, Sakari Ailus <sakari.ailus@linux.intel.com>, Mika Westerberg <mika.westerberg@linux.intel.com>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, ACPI Devel Maling List <linux-acpi@vger.kernel.org>, Lukas Wunner <lukas@wunner.de>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
List-Id: linux-efi@vger.kernel.org

The commit

  318a19718261 ("device property: refactor built-in properties support")

went way too far and brought a union aliasing. Partially revert it here
to get rid of union aliasing.

Note, Apple properties support is still utilizing this trick.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/base/property.c                 | 99 ++++++++++++++++++++-----
 drivers/firmware/efi/apple-properties.c |  8 +-
 include/linux/property.h                | 52 +++++++------
 3 files changed, 112 insertions(+), 47 deletions(-)

diff --git a/drivers/base/property.c b/drivers/base/property.c
index 8f205f6461ed..de19d7cc073b 100644
--- a/drivers/base/property.c
+++ b/drivers/base/property.c
@@ -56,6 +56,67 @@ pset_prop_get(const struct property_set *pset, const char *name)
 	return NULL;
 }
 
+static const void *property_get_pointer(const struct property_entry *prop)
+{
+	switch (prop->type) {
+	case DEV_PROP_U8:
+		if (prop->is_array)
+			return prop->pointer.u8_data;
+		return &prop->value.u8_data;
+	case DEV_PROP_U16:
+		if (prop->is_array)
+			return prop->pointer.u16_data;
+		return &prop->value.u16_data;
+	case DEV_PROP_U32:
+		if (prop->is_array)
+			return prop->pointer.u32_data;
+		return &prop->value.u32_data;
+	case DEV_PROP_U64:
+		if (prop->is_array)
+			return prop->pointer.u64_data;
+		return &prop->value.u64_data;
+	default:
+		if (prop->is_array)
+			return prop->pointer.str;
+		return &prop->value.str;
+	}
+}
+
+static void property_set_pointer(struct property_entry *prop, const void *pointer)
+{
+	switch (prop->type) {
+	case DEV_PROP_U8:
+		if (prop->is_array)
+			prop->pointer.u8_data = pointer;
+		else
+			prop->value.u8_data = *((u8 *)pointer);
+		break;
+	case DEV_PROP_U16:
+		if (prop->is_array)
+			prop->pointer.u16_data = pointer;
+		else
+			prop->value.u16_data = *((u16 *)pointer);
+		break;
+	case DEV_PROP_U32:
+		if (prop->is_array)
+			prop->pointer.u32_data = pointer;
+		else
+			prop->value.u32_data = *((u32 *)pointer);
+		break;
+	case DEV_PROP_U64:
+		if (prop->is_array)
+			prop->pointer.u64_data = pointer;
+		else
+			prop->value.u64_data = *((u64 *)pointer);
+		break;
+	default:
+		if (prop->is_array)
+			prop->pointer.str = pointer;
+		else
+			prop->value.str = pointer;
+	}
+}
+
 static const void *pset_prop_find(const struct property_set *pset,
 				  const char *propname, size_t length)
 {
@@ -65,10 +126,7 @@ static const void *pset_prop_find(const struct property_set *pset,
 	prop = pset_prop_get(pset, propname);
 	if (!prop)
 		return ERR_PTR(-EINVAL);
-	if (prop->is_array)
-		pointer = prop->pointer.raw_data;
-	else
-		pointer = &prop->value.raw_data;
+	pointer = property_get_pointer(prop);
 	if (!pointer)
 		return ERR_PTR(-ENODATA);
 	if (length > prop->length)
@@ -698,16 +756,17 @@ EXPORT_SYMBOL_GPL(fwnode_property_get_reference_args);
 
 static void property_entry_free_data(const struct property_entry *p)
 {
+	const void *pointer = property_get_pointer(p);
 	size_t i, nval;
 
 	if (p->is_array) {
-		if (p->is_string && p->pointer.str) {
+		if (p->type == DEV_PROP_STRING && p->pointer.str) {
 			nval = p->length / sizeof(const char *);
 			for (i = 0; i < nval; i++)
 				kfree(p->pointer.str[i]);
 		}
-		kfree(p->pointer.raw_data);
-	} else if (p->is_string) {
+		kfree(pointer);
+	} else if (p->type == DEV_PROP_STRING) {
 		kfree(p->value.str);
 	}
 	kfree(p->name);
@@ -716,7 +775,7 @@ static void property_entry_free_data(const struct property_entry *p)
 static int property_copy_string_array(struct property_entry *dst,
 				      const struct property_entry *src)
 {
-	char **d;
+	const char **d;
 	size_t nval = src->length / sizeof(*d);
 	int i;
 
@@ -734,40 +793,44 @@ static int property_copy_string_array(struct property_entry *dst,
 		}
 	}
 
-	dst->pointer.raw_data = d;
+	dst->pointer.str = d;
 	return 0;
 }
 
 static int property_entry_copy_data(struct property_entry *dst,
 				    const struct property_entry *src)
 {
+	const void *pointer = property_get_pointer(src);
+	const void *new;
 	int error;
 
 	if (src->is_array) {
 		if (!src->length)
 			return -ENODATA;
 
-		if (src->is_string) {
+		if (src->type == DEV_PROP_STRING) {
 			error = property_copy_string_array(dst, src);
 			if (error)
 				return error;
+			new = dst->pointer.str;
 		} else {
-			dst->pointer.raw_data = kmemdup(src->pointer.raw_data,
-							src->length, GFP_KERNEL);
-			if (!dst->pointer.raw_data)
+			new = kmemdup(pointer, src->length, GFP_KERNEL);
+			if (!new)
 				return -ENOMEM;
 		}
-	} else if (src->is_string) {
-		dst->value.str = kstrdup(src->value.str, GFP_KERNEL);
-		if (!dst->value.str && src->value.str)
+	} else if (src->type == DEV_PROP_STRING) {
+		new = kstrdup(src->value.str, GFP_KERNEL);
+		if (!new && src->value.str)
 			return -ENOMEM;
 	} else {
-		dst->value.raw_data = src->value.raw_data;
+		new = pointer;
 	}
 
 	dst->length = src->length;
 	dst->is_array = src->is_array;
-	dst->is_string = src->is_string;
+	dst->type = src->type;
+
+	property_set_pointer(dst, new);
 
 	dst->name = kstrdup(src->name, GFP_KERNEL);
 	if (!dst->name)
diff --git a/drivers/firmware/efi/apple-properties.c b/drivers/firmware/efi/apple-properties.c
index adaa9a3714b9..b2c2d5a45f91 100644
--- a/drivers/firmware/efi/apple-properties.c
+++ b/drivers/firmware/efi/apple-properties.c
@@ -13,6 +13,9 @@
  *
  * You should have received a copy of the GNU General Public License
  * along with this program; if not, see <http://www.gnu.org/licenses/>.
+ *
+ * FIXME: The approach is still based on union aliasing and should be
+ * replaced by a proper resource provider.
  */
 
 #define pr_fmt(fmt) "apple-properties: " fmt
@@ -96,12 +99,13 @@ static void __init unmarshal_key_value_pairs(struct dev_header *dev_header,
 		entry[i].name = key;
 		entry[i].length = val_len - sizeof(val_len);
 		entry[i].is_array = !!entry[i].length;
-		entry[i].pointer.raw_data = ptr + key_len + sizeof(val_len);
+		entry[i].type = DEV_PROP_U8;
+		entry[i].pointer.u8_data = ptr + key_len + sizeof(val_len);
 
 		if (dump_properties) {
 			dev_info(dev, "property: %s\n", entry[i].name);
 			print_hex_dump(KERN_INFO, pr_fmt(), DUMP_PREFIX_OFFSET,
-				16, 1, entry[i].pointer.raw_data,
+				16, 1, entry[i].pointer.u8_data,
 				entry[i].length, true);
 		}
 
diff --git a/include/linux/property.h b/include/linux/property.h
index 2eea4b310fc2..ac8a1ebc4c1b 100644
--- a/include/linux/property.h
+++ b/include/linux/property.h
@@ -178,7 +178,7 @@ static inline int fwnode_property_read_u64(const struct fwnode_handle *fwnode,
  * @name: Name of the property.
  * @length: Length of data making up the value.
  * @is_array: True when the property is an array.
- * @is_string: True when property is a string.
+ * @type: Type of the data in unions.
  * @pointer: Pointer to the property (an array of items of the given type).
  * @value: Value of the property (when it is a single item of the given type).
  */
@@ -186,10 +186,9 @@ struct property_entry {
 	const char *name;
 	size_t length;
 	bool is_array;
-	bool is_string;
+	enum dev_prop_type type;
 	union {
 		union {
-			const void *raw_data;
 			const u8 *u8_data;
 			const u16 *u16_data;
 			const u32 *u32_data;
@@ -197,7 +196,6 @@ struct property_entry {
 			const char * const *str;
 		} pointer;
 		union {
-			unsigned long long raw_data;
 			u8 u8_data;
 			u16 u16_data;
 			u32 u32_data;
@@ -213,55 +211,55 @@ struct property_entry {
  * and structs.
  */
 
-#define PROPERTY_ENTRY_INTEGER_ARRAY(_name_, _type_, _val_)	\
-(struct property_entry) {					\
-	.name = _name_,						\
-	.length = ARRAY_SIZE(_val_) * sizeof(_type_),		\
-	.is_array = true,					\
-	.is_string = false,					\
-	{ .pointer = { ._type_##_data = _val_ } },		\
+#define PROPERTY_ENTRY_INTEGER_ARRAY(_name_, _type_, _Type_, _val_)	\
+(struct property_entry) {						\
+	.name = _name_,							\
+	.length = ARRAY_SIZE(_val_) * sizeof(_type_),			\
+	.is_array = true,						\
+	.type = DEV_PROP_##_Type_,					\
+	{ .pointer = { ._type_##_data = _val_ } },			\
 }
 
 #define PROPERTY_ENTRY_U8_ARRAY(_name_, _val_)			\
-	PROPERTY_ENTRY_INTEGER_ARRAY(_name_, u8, _val_)
+	PROPERTY_ENTRY_INTEGER_ARRAY(_name_, u8, U8, _val_)
 #define PROPERTY_ENTRY_U16_ARRAY(_name_, _val_)			\
-	PROPERTY_ENTRY_INTEGER_ARRAY(_name_, u16, _val_)
+	PROPERTY_ENTRY_INTEGER_ARRAY(_name_, u16, U16, _val_)
 #define PROPERTY_ENTRY_U32_ARRAY(_name_, _val_)			\
-	PROPERTY_ENTRY_INTEGER_ARRAY(_name_, u32, _val_)
+	PROPERTY_ENTRY_INTEGER_ARRAY(_name_, u32, U32, _val_)
 #define PROPERTY_ENTRY_U64_ARRAY(_name_, _val_)			\
-	PROPERTY_ENTRY_INTEGER_ARRAY(_name_, u64, _val_)
+	PROPERTY_ENTRY_INTEGER_ARRAY(_name_, u64, U64, _val_)
 
 #define PROPERTY_ENTRY_STRING_ARRAY(_name_, _val_)		\
 (struct property_entry) {					\
 	.name = _name_,						\
 	.length = ARRAY_SIZE(_val_) * sizeof(const char *),	\
 	.is_array = true,					\
-	.is_string = true,					\
+	.type = DEV_PROP_STRING,				\
 	{ .pointer = { .str = _val_ } },			\
 }
 
-#define PROPERTY_ENTRY_INTEGER(_name_, _type_, _val_)	\
-(struct property_entry) {				\
-	.name = _name_,					\
-	.length = sizeof(_type_),			\
-	.is_string = false,				\
-	{ .value = { ._type_##_data = _val_ } },	\
+#define PROPERTY_ENTRY_INTEGER(_name_, _type_, _Type_, _val_)	\
+(struct property_entry) {					\
+	.name = _name_,						\
+	.length = sizeof(_type_),				\
+	.type = DEV_PROP_##_Type_,				\
+	{ .value = { ._type_##_data = _val_ } },		\
 }
 
 #define PROPERTY_ENTRY_U8(_name_, _val_)		\
-	PROPERTY_ENTRY_INTEGER(_name_, u8, _val_)
+	PROPERTY_ENTRY_INTEGER(_name_, u8, U8, _val_)
 #define PROPERTY_ENTRY_U16(_name_, _val_)		\
-	PROPERTY_ENTRY_INTEGER(_name_, u16, _val_)
+	PROPERTY_ENTRY_INTEGER(_name_, u16, U16, _val_)
 #define PROPERTY_ENTRY_U32(_name_, _val_)		\
-	PROPERTY_ENTRY_INTEGER(_name_, u32, _val_)
+	PROPERTY_ENTRY_INTEGER(_name_, u32, U32, _val_)
 #define PROPERTY_ENTRY_U64(_name_, _val_)		\
-	PROPERTY_ENTRY_INTEGER(_name_, u64, _val_)
+	PROPERTY_ENTRY_INTEGER(_name_, u64, U64, _val_)
 
 #define PROPERTY_ENTRY_STRING(_name_, _val_)		\
 (struct property_entry) {				\
 	.name = _name_,					\
 	.length = sizeof(_val_),			\
-	.is_string = true,				\
+	.type = DEV_PROP_STRING,			\
 	{ .value = { .str = _val_ } },			\
 }
 
-- 
2.17.0
