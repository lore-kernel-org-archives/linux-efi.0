From: Juergen Gross <jgross-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 1/3 v2] xen: Export xen_reboot
Date: Tue, 25 Apr 2017 06:02:18 +0200
Message-ID: <7396d142-98b0-9554-4cbd-477bb9e2f8e5@suse.com>
References: <20170424175839.5262-1-julien.grall@arm.com>
 <20170424175839.5262-2-julien.grall@arm.com>
 <41fd4caf-7554-7d54-6332-d227228a13ea@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <41fd4caf-7554-7d54-6332-d227228a13ea-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Boris Ostrovsky <boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Julien Grall <julien.grall-5wv7dgnIgG8@public.gmane.org>, xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org
Cc: sstabellini-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 24/04/17 20:21, Boris Ostrovsky wrote:
> On 04/24/2017 01:58 PM, Julien Grall wrote:
>> The helper xen_reboot will be called by the EFI code in a later patch.
>>
>> Note that the ARM version does not yet exist and will be added in a
>> later patch too.
>>
>> Signed-off-by: Julien Grall <julien.grall-5wv7dgnIgG8@public.gmane.org>
> 
> I don't think these changes are worth a whole patch. They can be folded
> into the third patch.

No, the 2nd patch needs this, too.

So:

Reviewed-by: Juergen Gross <jgross-IBi9RG/b67k@public.gmane.org>


Thanks, Juergen
