From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [PATCH v1 6/6] device property: Switch to use new generic UUID API
Date: Wed, 30 Aug 2017 15:46:34 +0200
Message-ID: <2441703.fLWibNLWr6@aspire.rjw.lan>
References: <20170719182857.73693-1-andriy.shevchenko@linux.intel.com> <6349641.0fe8FCM51k@aspire.rjw.lan> <20170830124141.oa32gzbgnafarkrh@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170830124141.oa32gzbgnafarkrh@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>, Mika Westerberg <mika.westerberg@linux.intel.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, devel@linuxdriverproject.org, sparmaintainer@unisys.com, devel@driverdev.osuosl.org, "open list:TI WILINK WIRELES..." <linux-wireless@vger.kernel.org>, linux-watchdog@vger.kernel.org, linux-efi <linux-efi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Lukas Wunner <lukas@wunner.de>
List-Id: linux-efi@vger.kernel.org

On Wednesday, August 30, 2017 2:41:41 PM CEST Christoph Hellwig wrote:
> On Wed, Jul 26, 2017 at 02:27:44AM +0200, Rafael J. Wysocki wrote:
> > > >> > Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
> > > >> > Cc: Mika Westerberg <mika.westerberg@linux.intel.com>
> > > >>
> > > >> Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> > > >
> > > > OK
> > > >
> > > > Andy, do you want me to apply this?
> > > 
> > > If you would like to.
> > > 
> > > The patch is now pretty independent since necessary stuff made v4.13-rc1.
> > 
> > OK
> 
> This didn't seem to make it into linux-next so far, though.

I have

3689d3d69072 ACPI: device property: Switch to use new generic UUID API

in my linux-next branch.  Isn't it this one?
