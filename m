From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 1/4] Documentation: arm: [U]EFI runtime services
Date: Thu, 27 Jun 2013 16:22:26 +0200
Message-ID: <201306271622.26494.arnd@arndb.de>
References: <1372183863-11333-1-git-send-email-leif.lindholm@linaro.org>
 <1372183863-11333-2-git-send-email-leif.lindholm@linaro.org>
 <CACxGe6tUpo31p6N0BZt_jdonuPP8ijvLBygC76wQ044EFsqOwA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <CACxGe6tUpo31p6N0BZt_jdonuPP8ijvLBygC76wQ044EFsqOwA@mail.gmail.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: linux-arm-kernel@lists.infradead.org
Cc: linux-efi@vger.kernel.org, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "patches@linaro.org" <patches@linaro.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Leif Lindholm <leif.lindholm@linaro.org>, Grant Likely <grant.likely@secretlab.ca>, matt.fleming@intel.com, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@linux.intel.com>
List-Id: linux-efi@vger.kernel.org

On Wednesday 26 June 2013, Grant Likely wrote:
> > index 0000000..5c48271
> > --- /dev/null
> > +++ b/Documentation/arm/uefi.txt
> > @@ -0,0 +1,39 @@
> > +The nomenclature EFI and UEFI are used interchangeably in this document.
> > +
> > +The implementation depends on receiving pointers to the UEFI memory map
> > +and System Table in a Flattened Device Tree - so is only available with
> > +CONFIG_OF.
> > +
> > +It (early) parses the FDT for the following parameters:
> 
> Need to state which node these properties can be found in. I recommend /chosen
> 
> I would also prefix all of the following properties with "linux,"
> since they are very much about what the Linux kernel needs for
> booting. EFI stub will be creating these properties specifically for
> Linux, and the LinuxLoader should do the same (until we eventually
> kill it).

Why not make it a separate /efi node instead, mirroring what we
have for hypervisor specific information and things like rtas?

	Arnd
