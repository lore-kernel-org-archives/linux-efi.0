From: "Luck, Tony" <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 1/2] efivars: Check max_size only if it is non-zero.
Date: Thu, 4 Apr 2013 16:00:36 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F1E0987DE@ORSMSX108.amr.corp.intel.com>
References: <1365080500-13677-1-git-send-email-richard@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1365080500-13677-1-git-send-email-richard-/L3Ra7n9ekc@public.gmane.org>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, "Fleming, Matt" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "cbouatmailru-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <cbouatmailru-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org" <ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, "keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org" <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org" <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

> Some (broken?) EFI implementations return always a MaximumVariableSize of 0,
> check against max_size only if it is non-zero.

The spec doesn't say that zero has any special meaning - so if an implementation
returns max_size == 0 but lets you set a variable to a size > 0, then I don't think
there is a need for parentheses or a "?" in this commit comment.

But if Linux silently accepts such broken EFI, then there is no feedback loop
to let EFI implementations know that they are broken.  In other areas we have
thrown out messages about firmware being broken ... perhaps:

	if (max_size == 0)
		printk_once("Broken EFI implementation is returning MaxVariableSize=0\n");

would help? After all there probably *is* a maximum size - but EFI isn't telling us what it is.

-Tony
