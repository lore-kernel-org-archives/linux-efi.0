From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/2] efivars: Check max_size only if it is non-zero.
Date: Fri, 05 Apr 2013 15:03:39 +0100
Message-ID: <515ED9BB.3060506@intel.com>
References: <1365080500-13677-1-git-send-email-richard@nod.at> <3908561D78D1C84285E8C5FCA982C28F1E0987DE@ORSMSX108.amr.corp.intel.com> <515DA677.8050805@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <515DA677.8050805-/L3Ra7n9ekc@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>
Cc: "Luck, Tony" <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "cbouatmailru-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <cbouatmailru-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org" <ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, "keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org" <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org" <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 04/04/13 17:12, Richard Weinberger wrote:
> Fair point. I'll add such a printk() to my patch and resend.

Also take a look at FW_BUG.
