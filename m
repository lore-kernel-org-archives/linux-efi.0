From: joeyli <jlee@suse.com>
Subject: Re: [PATCH v2 08/16] x86/efi: Carrying hibernation key by setup data
Date: Thu, 27 Aug 2015 17:28:26 +0800
Message-ID: <20150827092826.GD27415@linux-rxt1.site>
References: <1439273796-25359-1-git-send-email-jlee@suse.com>
 <1439273796-25359-9-git-send-email-jlee@suse.com>
 <20150821124026.GB3310@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150821124026.GB3310@codeblueprint.co.uk>
Sender: linux-pm-owner@vger.kernel.org
To: Matt Fleming <matt@codeblueprint.co.uk>
Cc: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Matthew Garrett <matthew.garrett@nebula.com>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Josh Boyer <jwboyer@redhat.com>, Vojtech Pavlik <vojtech@suse.cz>, Matt Fleming <matt.fleming@intel.com>, Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>
List-Id: linux-efi@vger.kernel.org

On Fri, Aug 21, 2015 at 01:40:26PM +0100, Matt Fleming wrote:
> On Tue, 11 Aug, at 02:16:28PM, Lee, Chun-Yi wrote:
> > For forwarding hibernation key from EFI stub to boot kernel, this patch
> > allocates setup data for carrying hibernation key, size and the status
> > of efi operating.
>  
> This could do with some more information, and include that the key is
> used to validate hibernate images.
> 
> But now that I think about it, is there a reason this patch hasn't
> been merged with patch 6? The memory leak I mentioned in patch 6
> becomes a non-issue in this one, so it would be good if these two
> could be squashed together.
>

OK, I will merge this patch with patch 6.

Actually the sequence of patches are from the order of my developing.
And, the purpose of code in this patch a bit different with patch 6,
so I didn't merge them together.
   
> > Reviewed-by: Jiri Kosina <jkosina@suse.com>
> > Tested-by: Jiri Kosina <jkosina@suse.com>
> > Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
> > ---
> >  arch/x86/boot/compressed/eboot.c      | 26 +++++++++++++++++++++++---
> >  arch/x86/include/uapi/asm/bootparam.h |  1 +
> >  2 files changed, 24 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
> > index 463aa9b..c838d09 100644
> > --- a/arch/x86/boot/compressed/eboot.c
> > +++ b/arch/x86/boot/compressed/eboot.c
> > @@ -1394,18 +1394,22 @@ static void setup_hibernation_keys(struct boot_params *params)
> >  {
> >  	unsigned long key_size;
> >  	unsigned long attributes;
> > +	struct setup_data *setup_data, *hibernation_setup_data;
> >  	struct hibernation_keys *keys;
> > +	unsigned long size = 0;
> >  	efi_status_t status;
> 
> One thing to be aware of is that eboot.c has mainly used the
> "reverse-christmas-tree" style of variable declarations, with longer
> lines first, and shorter ones following. I haven't mentioned it before
> because none of your changes seemed to be too different (and it's not
> a tree-wide convention), but the above setup_data line goes a bit too
> far.
> 
> Could you try and keep them ordered, longest line first?
> 

Sure, sorry for I didn't aware that before.

> >  
> >  	/* Allocate setup_data to carry keys */
> > +	size = sizeof(struct setup_data) + sizeof(struct hibernation_keys);
> >  	status = efi_call_early(allocate_pool, EFI_LOADER_DATA,
> > -				sizeof(struct hibernation_keys), &keys);
> > +				size, &hibernation_setup_data);
> >  	if (status != EFI_SUCCESS) {
> >  		efi_printk(sys_table, "Failed to alloc mem for hibernation keys\n");
> >  		return;
> >  	}
> >  
> > -	memset(keys, 0, sizeof(struct hibernation_keys));
> > +	memset(hibernation_setup_data, 0, size);
> > +	keys = (struct hibernation_keys *) hibernation_setup_data->data;
> >  
> >  	status = efi_call_early(get_variable, HIBERNATION_KEY,
> >  				&EFI_HIBERNATION_GUID, &attributes,
> > @@ -1419,7 +1423,8 @@ static void setup_hibernation_keys(struct boot_params *params)
> >  		if (status == EFI_SUCCESS) {
> >  			efi_printk(sys_table, "Cleaned existing hibernation key\n");
> >  			status = EFI_NOT_FOUND;
> > -		}
> > +		} else
> > +			goto clean_fail;
> 
> Please add braces for the 'else' clause. Also, please include a
> comment stating that the reason you jump to the label instead of
> returning is so that the EFI status error code can be recorded in
> hibernation_setup_data.
>

Thanks for suggestions, I will modify it.
 
> >  	}
> >  
> >  	if (status != EFI_SUCCESS) {
> > @@ -1436,6 +1441,21 @@ static void setup_hibernation_keys(struct boot_params *params)
> >  		if (status != EFI_SUCCESS)
> >  			efi_printk(sys_table, "Failed to set hibernation key\n");
> >  	}
> > +
> > +clean_fail:
> > +	hibernation_setup_data->type = SETUP_HIBERNATION_KEYS;
> > +	hibernation_setup_data->len = sizeof(struct hibernation_keys);
> > +	hibernation_setup_data->next = 0;
> > +	keys->hkey_status = efi_status_to_err(status);
> > +
> > +	setup_data = (struct setup_data *)params->hdr.setup_data;
> > +	while (setup_data && setup_data->next)
> > +		setup_data = (struct setup_data *)setup_data->next;
> > +
> > +	if (setup_data)
> > +		setup_data->next = (unsigned long)hibernation_setup_data;
> > +	else
> > +		params->hdr.setup_data = (unsigned long)hibernation_setup_data;
> 
> This label name is a little confusing because you reach it both when
> the EFI boot variable was successfully created and when a bogus EFI
> variable failed to be deleted, i.e. it's not always reached because of
> a failure.
> 
> How about 'setup' or simply 'out' ?
>

I will change the label to 'setup' that match with setting setup_data.
 
> -- 
> Matt Fleming, Intel Open Source Technology Center


Thanks a lot!
Joey Lee
