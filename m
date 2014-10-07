From: Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 07/44] qnap-poweroff: Drop reference to pm_power_off from
 devicetree bindings
Date: Tue, 7 Oct 2014 08:57:13 -0700
Message-ID: <20141007155713.GB28835@roeck-us.net>
References: <1412659726-29957-1-git-send-email-linux@roeck-us.net>
 <1412659726-29957-8-git-send-email-linux@roeck-us.net>
 <20141007110219.GE24725@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <20141007110219.GE24725@leverpostej>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: "linux-m32r-ja@ml.linux-m32r.org" <linux-m32r-ja@ml.linux-m32r.org>, "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>, "linux-m68k@vger.kernel.org" <linux-m68k@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>, "linux-xtensa@linux-xtensa.org" <linux-xtensa@linux-xtensa.org>, "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>, "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>, "lguest@lists.ozlabs.org" <lguest@lists.ozlabs.org>, "linux-c6x-dev@linux-c6x.org" <linux-c6x-dev@linux-c6x.org>, "linux-hexagon@vger.kernel.org" <linux-hexagon@vger.kernel.org>, "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, Pawel Moll <Pawel.Moll@arm.com>, "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>dev
List-Id: linux-efi@vger.kernel.org

On Tue, Oct 07, 2014 at 12:02:19PM +0100, Mark Rutland wrote:
> On Tue, Oct 07, 2014 at 06:28:09AM +0100, Guenter Roeck wrote:
> > Replace reference to pm_power_off (which is an implementation detail)
> > and replace it with a more generic description of the driver's functionality.
> > 
> > Cc: Rob Herring <robh+dt@kernel.org>
> > Cc: Pawel Moll <pawel.moll@arm.com>
> > Cc: Mark Rutland <mark.rutland@arm.com>
> > Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> > ---
> >  Documentation/devicetree/bindings/power_supply/qnap-poweroff.txt | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/Documentation/devicetree/bindings/power_supply/qnap-poweroff.txt b/Documentation/devicetree/bindings/power_supply/qnap-poweroff.txt
> > index af25e77..1e2260a 100644
> > --- a/Documentation/devicetree/bindings/power_supply/qnap-poweroff.txt
> > +++ b/Documentation/devicetree/bindings/power_supply/qnap-poweroff.txt
> > @@ -3,8 +3,8 @@
> >  QNAP NAS devices have a microcontroller controlling the main power
> >  supply. This microcontroller is connected to UART1 of the Kirkwood and
> >  Orion5x SoCs. Sending the character 'A', at 19200 baud, tells the
> > -microcontroller to turn the power off. This driver adds a handler to
> > -pm_power_off which is called to turn the power off.
> > +microcontroller to turn the power off. This driver installs a handler
> > +to power off the system.
> 
> I'd remove the last sentence -- the driver is also independent of the
> HW, and the description of how the power off works at the HW level is
> sufficient.
> 
Done.

> With that:
> 
> Acked-by: Mark Rutland <mark.rutland@arm.com>
> 
Thanks!

Guenter
