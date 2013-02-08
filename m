From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v5 -next 0/2] make efivars/efi_pstore interrupt-safe
Date: Fri, 08 Feb 2013 22:46:06 +0000
Message-ID: <1360363566.7515.310.camel@mfleming-mobl1.ger.corp.intel.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D414A5419C@USINDEM103.corp.hds.com>
	 <A5ED84D3BB3A384992CBB9C77DEDA4D414A884D6@USINDEM103.corp.hds.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D414A884D6-ohthHghroY0jroPwUH3sq+6wyyQG6/Uh@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org>
Cc: "Luck, Tony (tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org)" <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org" <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "dle-develop-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <dle-develop-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, Satoru Moriya <satoru.moriya-7rDLJAbr9SE@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "cbouatmailru-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <cbouatmailru-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "dzickus-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dzickus-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 2013-02-08 at 22:31 +0000, Seiji Aguchi wrote:
> Matt,
> 
> Can you please take a look at this patchset which removes
> create_sysfs_entries() from efi_pstore_write()?
> 
> It has been updated in accordance with Mike's comment and fixes an
> actual bug.
> http://comments.gmane.org/gmane.linux.kernel.efi/406

OK, I'll find some time to review these.
