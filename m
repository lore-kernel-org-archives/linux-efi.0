From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH v4] efivars,efi-pstore: Hold off deletion of sysfs entry
 until the scan is completed
Date: Mon, 11 Nov 2013 15:27:46 +0000
Message-ID: <20131111152746.GG22636@console-pimps.org>
References: <52715D9E.10701@hds.com>
 <20131106085127.GB22856@console-pimps.org>
 <CA+8MBb+G3rc711u4ZmpYQTUGXyeBUGi-K_YBWenDyGjXJYa0qA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CA+8MBb+G3rc711u4ZmpYQTUGXyeBUGi-K_YBWenDyGjXJYa0qA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tony Luck <tony.luck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, tomoki.sekiyama-7rDLJAbr9SE@public.gmane.org, "dle-develop-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <dle-develop-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, Madper Xie <cxie-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, 06 Nov, at 01:35:41PM, Tony Luck wrote:
> On Wed, Nov 6, 2013 at 12:51 AM, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org> wrote:
> > Tony, want me to pick this up since it touches various EFI bits?
> 
> Since there are now no generic pstore changes - it is all in the efi
> backend ... yes,
> it makes sense for you to take this.

Applied, thanks everyone.

-- 
Matt Fleming, Intel Open Source Technology Center
