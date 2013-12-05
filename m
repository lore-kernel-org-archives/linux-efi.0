From: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/3] arm64: add EFI runtime services
Date: Thu, 05 Dec 2013 10:52:41 -0500
Message-ID: <1386258761.1861.137.camel@deneb.redhat.com>
References: <1385762712-17043-1-git-send-email-msalter@redhat.com>
	 <1385762712-17043-4-git-send-email-msalter@redhat.com>
	 <20131205152510.GB974@darko.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131205152510.GB974-rtzwXk+D4rEjOxct69p1ducL+3YJyIBv@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Will Deacon <Will.Deacon-5wv7dgnIgG8@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, 2013-12-05 at 15:25 +0000, Catalin Marinas wrote:
> I lost track of the early_ioremap status for arm/arm64? Was there more
> progress since October (I think)?

See the two patch series:

 https://lkml.org/lkml/2013/11/25/474

and

 https://lkml.org/lkml/2013/11/27/621

The latter early_ioremap depends on the first although there are no
arm64 bits in the first. All of the arm64 early_ioremap stuff is in
the latter.

--Mark
