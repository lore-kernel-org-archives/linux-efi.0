From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: re: efi: Add 'capsule' update support
Date: Mon, 2 May 2016 21:25:00 +0300
Message-ID: <20160502182500.GA3461@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Hello Matt Fleming,

The patch f0133f3c5b8b: "efi: Add 'capsule' update support" from Apr
25, 2016, leads to the following static checker warning:

	drivers/firmware/efi/capsule.c:109 efi_capsule_supported()
	warn: did you mean to pass the address of 'capsule'

drivers/firmware/efi/capsule.c
    91  int efi_capsule_supported(efi_guid_t guid, u32 flags, size_t size, int *reset)
    92  {
    93          efi_capsule_header_t *capsule;
    94          efi_status_t status;
    95          u64 max_size;
    96          int rv = 0;
    97  
    98          if (flags & ~EFI_CAPSULE_SUPPORTED_FLAG_MASK)
    99                  return -EINVAL;
   100  
   101          capsule = kmalloc(sizeof(*capsule), GFP_KERNEL);
   102          if (!capsule)
   103                  return -ENOMEM;
   104  
   105          capsule->headersize = capsule->imagesize = sizeof(*capsule);
   106          memcpy(&capsule->guid, &guid, sizeof(efi_guid_t));
   107          capsule->flags = flags;
   108  
   109          status = efi.query_capsule_caps(&capsule, 1, &max_size, reset);
                                                ^^^^^^^^
If we modify capsule inside this function call then at the end of the
function we aren't freeing the original pointer that we allocated.

   110          if (status != EFI_SUCCESS) {
   111                  rv = efi_status_to_err(status);
   112                  goto out;
   113          }
   114  
   115          if (size > max_size)
   116                  rv = -ENOSPC;
   117  out:
   118          kfree(capsule);
   119          return rv;
   120  }

regards,
dan carpenter
