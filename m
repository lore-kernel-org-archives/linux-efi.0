From: Tony Luck <tony.luck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v4] efivars,efi-pstore: Hold off deletion of sysfs entry
 until the scan is completed
Date: Wed, 6 Nov 2013 13:35:41 -0800
Message-ID: <CA+8MBb+G3rc711u4ZmpYQTUGXyeBUGi-K_YBWenDyGjXJYa0qA@mail.gmail.com>
References: <52715D9E.10701@hds.com>
	<20131106085127.GB22856@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131106085127.GB22856-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, tomoki.sekiyama-7rDLJAbr9SE@public.gmane.org, "dle-develop-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <dle-develop-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, Madper Xie <cxie-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Nov 6, 2013 at 12:51 AM, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org> wrote:
> Tony, want me to pick this up since it touches various EFI bits?

Since there are now no generic pstore changes - it is all in the efi
backend ... yes,
it makes sense for you to take this.

Thanks

[And thanks to Madper Xie for patiently coding through all these variations]

-Tony
