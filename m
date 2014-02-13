From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [BUG] can't boot up: unable to handle kernel paging request at ffffffffff340003
Date: Fri, 14 Feb 2014 00:48:16 +0100
Message-ID: <2332416.4VqEbrnVLy@vostro.rjw.lan>
References: <8738jr5t3e.fsf@redhat.com> <87k3czdtbf.fsf@redhat.com> <20140213171024.GA4420@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140213171024.GA4420@srcf.ucam.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Madper Xie <cxie@redhat.com>, Matt Fleming <matt@console-pimps.org>, Toshi Kani <toshi.kani@hp.com>, Matt Fleming <matt.fleming@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Josh Triplett <josh@joshtriplett.org>
List-Id: linux-efi@vger.kernel.org

On Thursday, February 13, 2014 05:10:25 PM Matthew Garrett wrote:
> On Thu, Feb 13, 2014 at 09:40:36PM +0800, Madper Xie wrote:
> 
> > Thanks Matt. This patch fix the panic. And ioremap warning disappeared
> > after apply your patch.
> 
> The spec was originally unclear on what the valid bit meant - I think 
> this is the right thing to do.

Agreed.

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
