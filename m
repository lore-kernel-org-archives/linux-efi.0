From: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Subject: Re: [edk2] Corrupted EFI region
Date: Mon, 16 Sep 2013 17:27:40 +0100
Message-ID: <20130916162739.GA29868@srcf.ucam.org>
References: <20130807151935.GJ17920@pd.tnic>
 <CCFD3CBD-62B0-4046-B96D-18CB1A815F72@apple.com>
 <20130807201908.GG2515@console-pimps.org>
 <D5982201-6DC4-469F-812A-74A8402ADEE9@apple.com>
 <20130808101730.GJ2515@console-pimps.org>
 <20130913203812.GA312@anatevka.fc.hp.com>
 <20130916105920.GB2697@console-pimps.org>
 <5236F096.8040702@redhat.com>
 <20130916155751.GA3636@leaf>
 <523730F2.40408@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <523730F2.40408-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Laszlo Ersek <lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, jerry.hoemann-VXdhtT5mjnY@public.gmane.org, Andrew Fish <afish-2kanFRK1NckAvxtiuMwx3w@public.gmane.org>, edk2-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Gleb Natapov <gleb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Brian Richardson <brian.richardson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Randy Wright <rwright-VXdhtT5mjnY@public.gmane.org>, Linn Crosetto <linn.crosetto-VXdhtT5mjnY@public.gmane.org>, terry.lee-VXdhtT5mjnY@public.gmane.org, samer.el-haj-mahmoud-VXdhtT5mjnY@public.gmane.org, randy.pawell-VXdhtT5mjnY@public.gmane.org, chrisp-VXdhtT5mjnY@public.gmane.org, linda.knippers-VXdhtT5mjnY@public.gmane.org, dong.wei-VXdhtT5mjnY@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Chao Zhang <chao.b.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Yao Jiewen <jiewen.yao-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Sep 16, 2013 at 06:25:22PM +0200, Laszlo Ersek wrote:

> Or are you alluding to UEFI firmware that's not based on TianoCore?

Most BGRT implementations are IBV specific rather than coming from 
Tiano. The ACPI spec says that the image should be stored in 
EfiBootServicesData, and most implementations follow that.

-- 
Matthew Garrett | mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org
