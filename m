From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 4/6] efi: Get the secure boot status
Date: Tue, 22 Nov 2016 14:57:28 +0000
Message-ID: <26282.1479826648@warthog.procyon.org.uk>
References: <7199.1479826047@warthog.procyon.org.uk> <20161122104401.GC1552@wunner.de> <20161117123731.GA11573@wunner.de> <147977472115.6360.13015228230799369019.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <7199.1479826047-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Content-ID: <26281.1479826648.1-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> That makes it less clear.  I think something like this makes it much more
> obvious:
> 
>     static efi_status_t get_efi_var(const efi_char16_t *name,
> 				const efi_guid_t *vendor,
> 				u32 *attr,
> 				unsigned long *data_size, void *data)
>     {
> 	return efi_call_runtime(get_variable,
> 				(efi_char16_t *)name, (efi_guid_t *)vendor,
> 				attr, data_size, data);
>     }
> 
> And then doing:
> 
> 	status = get_efi_var(efi_SecureBoot_name, &efi_variable_guid,
> 			     NULL, &size, &val);
> 
> which the compiler will inline.

Of course, it has to be a macro because efi_call_runtime() has an undeclared
argument on ARM...

David
