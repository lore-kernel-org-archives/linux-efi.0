From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 06/13] x86/efi: Build our own EFI services pointer table
Date: Fri, 28 Feb 2014 07:14:24 -0800
Message-ID: <fdeff5fb-f11d-4ec1-8ab6-00a6b2b9b632@email.android.com>
References: <1393530660-12692-1-git-send-email-matt@console-pimps.org> <1393530660-12692-7-git-send-email-matt@console-pimps.org> <530F9B71.1030405@zytor.com> <20140228141206.GA17881@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140228141206.GA17881-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Much better indeed.

On February 28, 2014 6:12:06 AM PST, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org> wrote:
>On Thu, 27 Feb, at 12:09:21PM, H. Peter Anvin wrote:
>> 
>> That being said, is there a reason we can't simply write this as:
>> 
>> 	efi_system_table_##bits##_t table;
>> 
>> 	/* ... */
>> 
>> 	func = (typeof(func))(unsigned long)table->con_out;
>> 	c->text_output = *func;
>
>Oh, yeah that's much better. I was being overly cautious with trying to
>not dereference the pointers in the regular efi_system_table_t, and
>what
>you've written is much more compact both in terms of C and generated
>object code. Things end up looking like this,
>
>---
>
>#define BOOT_SERVICES(bits)						\
>static void setup_boot_services##bits(struct efi_config *c)		\
>{									\
>	efi_system_table_##bits##_t *table;				\
>	efi_boot_services_##bits##_t *bt;				\
>									\
>	table = (typeof(table))sys_table;				\
>									\
>	c->text_output = table->con_out;				\
>									\
>	bt = (typeof(bt))(unsigned long)(table->boottime);		\
>									\
>	c->allocate_pool = bt->allocate_pool;				\
>	c->allocate_pages = bt->allocate_pages;				\
>	c->get_memory_map = bt->get_memory_map;				\
>	c->free_pool = bt->free_pool;					\
>	c->free_pages = bt->free_pages;					\
>	c->locate_handle = bt->locate_handle;				\
>	c->handle_protocol = bt->handle_protocol;			\
>	c->exit_boot_services = bt->exit_boot_services;			\
>}
>BOOT_SERVICES(32);
>BOOT_SERVICES(64);

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
