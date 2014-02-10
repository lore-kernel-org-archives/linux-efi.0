From: Yuhong Bao <yuhongbao_386-PkbjNfxxIARBDgjK7y7TUQ@public.gmane.org>
Subject: Linux, UEFI, and Chromebooks (was RE: [PATCH 0/4] EFI 1:1 mapping)
Date: Sun, 9 Feb 2014 19:59:25 -0800
Message-ID: <BLU177-W291F3CD8A955C71C799C8C3900@phx.gbl>
References: <1370177770-26661-1-git-send-email-bp@alien8.de>
 <20130602225620.GA5496@srcf.ucam.org> <20130603081148.GB13607@nazgul.tnic>
 <1370269642.2910.4.camel@dabdike> <20130603143010.GA20252@srcf.ucam.org>
 <1370270282.2910.9.camel@dabdike>
 <20130603152122.GA21312,<20130603164237.GA23146@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130603164237.GA23146-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, James Bottomley <james.bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Linux EFI <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, X86-ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

> On Mon, Jun 03, 2013 at 09:35:07AM -0700, James Bottomley wrote:
>> On Mon, 2013-06-03 at 17:24 +0100, Matthew Garrett wrote:
>>> That seems optimistic. Windows never calls QueryVariableInfo() during
>>> boot services, so what makes you think doing so has ever been tested?
>>
>> It's used by the UEFI shell package ... every system which boots to the
>> shell automatically tests this. I know no locked down UEFI system ships
>> with a shell but almost every system in test has a Shell in some form,
>> so I think its fairly safe to call it from boot services.
>
> Why do you persist in this belief that all system vendors are going to
> have run a shell, let alone any kind of test suite? That runs counter to
> everything we've learned about x86 firmware. People verify that it runs
> Windows and then ship it.
What is frustrating here is that Google decided that x86 Chromebooks should use different firmware, otherwise it would be easier to convince vendor to fix these firmware bugs.

Yuhong Bao 		 	   		  --
To unsubscribe from this list: send the line "unsubscribe linux-efi" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
