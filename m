From: Nayna Jain <nayna@linux.ibm.com>
Subject: Re: [PATCH v2 5/7] efi: Import certificates from UEFI Secure Boot
Date: Wed, 12 Dec 2018 23:01:15 +0530
Message-ID: <d36bfd7c-7564-778b-1e75-5b835d40b6f1@linux.ibm.com>
References: <20181208202705.18673-1-nayna@linux.ibm.com>
 <20181208202705.18673-6-nayna@linux.ibm.com>
 <alpine.LRH.2.21.1812120547110.11653@namei.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.21.1812120547110.11653@namei.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: James Morris <jmorris@namei.org>
Cc: linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, zohar@linux.ibm.com, dhowells@redhat.com, jforbes@redhat.com, seth.forshee@canonical.com, kexec@lists.infradead.org, keyrings@vger.kernel.org, vgoyal@redhat.com, ebiederm@xmission.com, mpe@ellerman.id.au, Josh Boyer <jwboyer@fedoraproject.org>
List-Id: linux-efi@vger.kernel.org



On 12/12/2018 12:17 AM, James Morris wrote:
> On Sun, 9 Dec 2018, Nayna Jain wrote:
>
>> +/*
>> + * Blacklist an X509 TBS hash.
>> + */
>> +static __init void uefi_blacklist_x509_tbs(const char *source,
>> +					   const void *data, size_t len)
>> +{
>> +	char *hash, *p;
>> +
>> +	hash = kmalloc(4 + len * 2 + 1, GFP_KERNEL);
>> +	if (!hash)
>> +		return;
>> +	p = memcpy(hash, "tbs:", 4);
>> +	p += 4;
>> +	bin2hex(p, data, len);
>> +	p += len * 2;
>> +	*p = 0;
>> +
>> +	mark_hash_blacklisted(hash);
>> +	kfree(hash);
>> +}
>> +
>> +/*
>> + * Blacklist the hash of an executable.
>> + */
>> +static __init void uefi_blacklist_binary(const char *source,
>> +					 const void *data, size_t len)
>> +{
>> +	char *hash, *p;
>> +
>> +	hash = kmalloc(4 + len * 2 + 1, GFP_KERNEL);
>> +	if (!hash)
>> +		return;
>> +	p = memcpy(hash, "bin:", 4);
>> +	p += 4;
>> +	bin2hex(p, data, len);
>> +	p += len * 2;
>> +	*p = 0;
>> +
>> +	mark_hash_blacklisted(hash);
>> +	kfree(hash);
>> +}
>>
> These could be refactored into one function.
>
>

Thanks James for reviewing.

Yes, the code should be refactored.  However, I think making it a single 
function would require adding a new field to the function callback 
definitions as well. Probably, a simpler approach would be to define a 
common function uefi_blacklist_hash(...)  which can then be used by the 
two functions uefi_blacklist_x509_tbs(...) and 
uefi_blacklist_binary(...). These two functions now act as wrapper 
functions. Below is the example code:

+/*
+ * Blacklist a hash.
+ */
+static __init void uefi_blacklist_hash(const char *source, const void 
*data,
+                                 size_t len, char *type, size_t type_len)
+{
+       char *hash, *p;
+
+       hash = kmalloc(type_len + len * 2 + 1, GFP_KERNEL);
+       if (!hash)
+               return;
+       p = memcpy(hash, type, type_len);
+       p += type_len;
+       bin2hex(p, data, len);
+       p += len * 2;
+       *p = 0;
+
+       mark_hash_blacklisted(hash);
+       kfree(hash);
+}
+
+/*
+ * Blacklist an X509 TBS hash.
+ */
+static __init void uefi_blacklist_x509_tbs(const char *source,
+                                          const void *data, size_t len)
+{
+       uefi_blacklist_hash(source, data, len, "tbs:" , 4);
+}
+
+/*
+ * Blacklist the hash of an executable.
+ */
+static __init void uefi_blacklist_binary(const char *source,
+                                        const void *data, size_t len)
+{
+       uefi_blacklist_hash(source, data, len, "bin:" , 4);
+}


Thanks & Regards,
    - Nayna
