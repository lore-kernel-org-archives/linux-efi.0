From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [PATCH v1 6/6] device property: Switch to use new generic UUID API
Date: Wed, 26 Jul 2017 02:27:44 +0200
Message-ID: <6349641.0fe8FCM51k@aspire.rjw.lan>
References: <20170719182857.73693-1-andriy.shevchenko@linux.intel.com>
 <2908341.aERReitNcd@aspire.rjw.lan>
 <CAHp75Vd6KenS3vQBgTJL=iE790Rrtzj11gvPK=KLE98bjcPm6w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <CAHp75Vd6KenS3vQBgTJL=iE790Rrtzj11gvPK=KLE98bjcPm6w@mail.gmail.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-efi <linux-efi@vger.kernel.org>, linux-watchdog@vger.kernel.org, sparmaintainer@unisys.com, "open list:TI WILINK WIRELES..." <linux-wireless@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, Lukas Wunner <lukas@wunner.de>, devel@linuxdriverproject.org, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Mika Westerberg <mika.westerberg@linux.intel.com>, Christoph Hellwig <hch@lst.de>
List-Id: linux-efi@vger.kernel.org

On Wednesday, July 26, 2017 03:35:01 AM Andy Shevchenko wrote:
> On Wed, Jul 26, 2017 at 3:21 AM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> > On Tuesday, July 25, 2017 05:12:35 PM Mika Westerberg wrote:
> >> On Wed, Jul 19, 2017 at 09:28:57PM +0300, Andy Shevchenko wrote:
> >> > There are new types and helpers that are supposed to be used in new code.
> >> >
> >> > As a preparation to get rid of legacy types and API functions do
> >> > the conversion here.
> >> >
> >> > Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
> >> > Cc: Mika Westerberg <mika.westerberg@linux.intel.com>
> >>
> >> Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> >
> > OK
> >
> > Andy, do you want me to apply this?
> 
> If you would like to.
> 
> The patch is now pretty independent since necessary stuff made v4.13-rc1.

OK
