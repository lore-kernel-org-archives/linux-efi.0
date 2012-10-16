From: Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: Re: [PATCH 5/5] efivarfs: efivarfs_fill_super() ensure we clean up
 correctly on error
Date: Tue, 16 Oct 2012 17:16:37 +0800
Message-ID: <507D25F5.3030001@canonical.com>
References: <1349416496.810727.310563927016.1.gpush@pecola> <1349951541-20498-1-git-send-email-apw@canonical.com> <1349951541-20498-6-git-send-email-apw@canonical.com> <5076D1EC.1060100@canonical.com> <20121011160633.GA23494@dm>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121011160633.GA23494@dm>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Whitcroft <apw-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Hi Andy,

>> If we break out of the loop on the second (and onwards) iteration,
>> won't we still have the other inodes and dentries remaining
>> allocated?
>
> As we calling this from the mount_single() wrapper:
>
>          return mount_single(fs_type, flags, data, efivarfs_fill_super);
>
>
> which does this:
>
>      struct dentry *mount_single(struct file_system_type *fs_type,
> 	    int flags, void *data,
> 	    int (*fill_super)(struct super_block *, void *, int))
>      {
>      [...]
> 		    error = fill_super(s, data, flags & MS_SILENT ? 1 : 0);
> 		    if (error) {
> 			    deactivate_locked_super(s);
> 			    return ERR_PTR(error);
> 		    }
>      [...]
>
> I am expecting us to get called back via deactivate_locked_super(),
> which calls sb->kill_sb() which is:
>
>      static void efivarfs_kill_sb(struct super_block *sb)
>      {
> 	    kill_litter_super(sb);
> 	    efivarfs_sb = NULL;
>      }
>
> Which I believe will clean them up.

Awesome, thanks for that. Looks good to me.

Acked-by: Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

Cheers,


Jeremy Kerr

--
To unsubscribe from this list: send the line "unsubscribe linux-efi" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
