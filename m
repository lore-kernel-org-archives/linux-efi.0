From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [patch] efi: small leak on error
Date: Tue, 20 Jan 2015 15:59:33 +0000
Message-ID: <20150120155933.GA12079@codeblueprint.co.uk>
References: <20150115092121.GA17976@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150115092121.GA17976@mwanda>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, 15 Jan, at 12:21:21PM, Dan Carpenter wrote:
> The "> 0" here should ">= 0" so we free map_entries[0].
> 
> Fixes: 926172d46038 ('efi: Export EFI runtime memory mapping to sysfs')
> Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> 
> diff --git a/drivers/firmware/efi/runtime-map.c b/drivers/firmware/efi/runtime-map.c
> index 018c29a..87b8e3b 100644
> --- a/drivers/firmware/efi/runtime-map.c
> +++ b/drivers/firmware/efi/runtime-map.c
> @@ -191,7 +191,7 @@ int __init efi_runtime_map_init(struct kobject *efi_kobj)
>  
>  	return 0;
>  out_add_entry:
> -	for (j = i - 1; j > 0; j--) {
> +	for (j = i - 1; j >= 0; j--) {
>  		entry = *(map_entries + j);
>  		kobject_put(&entry->kobj);
>  	}

Thanks Dan, I've applied this for v3.20 and added Dave's ACK.

One thing: I updated the title to be a little more descriptive. Because
the "efi" code has grown rather large over the past few years, it's
really helpful to pinpoint exactly what area a patch is touching (in
this case, it's the runtime map code).

---

>From 86d68a58d00db3770735b5919ef2c6b12d7f06f3 Mon Sep 17 00:00:00 2001
From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Date: Thu, 15 Jan 2015 12:21:21 +0300
Subject: [PATCH] efi: Small leak on error in runtime map code

The "> 0" here should ">= 0" so we free map_entries[0].

Fixes: 926172d46038 ('efi: Export EFI runtime memory mapping to sysfs')
Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Acked-by: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/firmware/efi/runtime-map.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/runtime-map.c b/drivers/firmware/efi/runtime-map.c
index 018c29a26615..87b8e3b900d2 100644
--- a/drivers/firmware/efi/runtime-map.c
+++ b/drivers/firmware/efi/runtime-map.c
@@ -191,7 +191,7 @@ int __init efi_runtime_map_init(struct kobject *efi_kobj)
 
 	return 0;
 out_add_entry:
-	for (j = i - 1; j > 0; j--) {
+	for (j = i - 1; j >= 0; j--) {
 		entry = *(map_entries + j);
 		kobject_put(&entry->kobj);
 	}
-- 
1.9.3

-- 
Matt Fleming, Intel Open Source Technology Center
