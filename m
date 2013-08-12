From: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V3 RFC 00/16]  EFI stub for ARM
Date: Mon, 12 Aug 2013 10:02:40 -0400
Message-ID: <1376316160.32237.17.camel@t520.redhat.com>
References: <1376090777-20090-1-git-send-email-roy.franz@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1376090777-20090-1-git-send-email-roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, dave.martin-5wv7dgnIgG8@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Fri, 2013-08-09 at 16:26 -0700, Roy Franz wrote:
> * Change FDT memory allocation to retry with a larger allocation if
>   first educated guess is inadequate.

With this change, it looks like you no longer free the original cmdline
and fdt memory. The current flow looks like:

  retry:
     allocate_memory_for_expanded_fdt
     get_memory_map
     if (update_fdt() fails) {
        free new_fdt and memory_map
        goto retry
     }

So, this keeps the original fdt around and uses it as a starting point
for newly allocated expanded fdt. You don't know if the new fdt is big
enough until update_fdt() succeeds. But at that point, you already wrote
the efi-runtime-mmap property with the memory_map still having the
original cmdline and fdt in it.

I think you should be able to have an expand_fdt() function which bumps
the fdt size and uses the current fdt as the starting point instead of
the original fdt. That way you can free the original fdt on the first
iteration and free the original cmdline as soon as it is successfully
written. Then the last thing you do if get the memory_map and write it.

--Mark



        
     
