From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [RFC][PATCH 3/7] efivars: New efivar_entry API
Date: Fri, 08 Feb 2013 22:25:00 +0000
Message-ID: <1360362300.7515.307.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1360357158-8168-1-git-send-email-matt@console-pimps.org>
	 <1360357158-8168-4-git-send-email-matt@console-pimps.org>
	 <A5ED84D3BB3A384992CBB9C77DEDA4D414A88489@USINDEM103.corp.hds.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D414A88489-ohthHghroY0jroPwUH3sq+6wyyQG6/Uh@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 2013-02-08 at 22:13 +0000, Seiji Aguchi wrote:
> Please don't allocate memory dynamically in the efi_pstore_write()
> because efi_pstore_write() is 
> called in an interrupt context like oops and panic.

efi_pstore_write() already calls efivar_create_sysfs_entry() which does
kzalloc() anyway. Obviously this needs fixing, but it doesn't need to be
done in this series. Unless there's some pstore patches that fix that
somewhere? I know you sent some patches that moved things to a thread,
unfortunately I haven't had chance to look at them.

> Also, a whole process of query_info() + entry_set() should be
> protected by a single spin lock()
> Because if efi_pstore_write() runs concurrently, a result of
> query_info() may be meaningless...
> 
> So, how about introducing query_info_nolock and entry_set_nolock()?
> 
> spin_lock()
> query_info_nolock()
> entry_set_nolock()
> spin_unlock()
> 
> IMO, efivarfs_file_write() should be fixed as above.

Isn't the write() path protected by ->buf_lock? I didn't think it was
possible to have two CPUs in the write() path simultaneously.

-- 
Matt Fleming, Intel Open Source Technology Center
