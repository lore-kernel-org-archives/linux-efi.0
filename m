From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH v2] device property: Get rid of union aliasing
Date: Mon, 14 May 2018 15:48:09 +0300
Message-ID: <f2109d06a0755dd2d9dc807c1e13dd2c19903905.camel@linux.intel.com>
References: <20180508131547.44366-1-andriy.shevchenko@linux.intel.com>
         <20180514121817.GA27869@wunner.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180514121817.GA27869@wunner.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Lukas Wunner <lukas@wunner.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-efi@vger.kernel.org, Sakari Ailus <sakari.ailus@linux.intel.com>, Mika Westerberg <mika.westerberg@linux.intel.com>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, ACPI Devel Maling List <linux-acpi@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On Mon, 2018-05-14 at 14:18 +0200, Lukas Wunner wrote:
> On Tue, May 08, 2018 at 04:15:47PM +0300, Andy Shevchenko wrote:
> > --- a/drivers/firmware/efi/apple-properties.c
> > +++ b/drivers/firmware/efi/apple-properties.c
> > @@ -13,6 +13,9 @@
> >   *
> >   * You should have received a copy of the GNU General Public
> > License
> >   * along with this program; if not, see <http://www.gnu.org/license
> > s/>.
> > + *
> > + * FIXME: The approach is still based on union aliasing and should
> > be
> > + * replaced by a proper resource provider.
> 
> Why?  All Apple EFI properties are either boolean or u8 arrays.
> You've correctly changed this file to always supply u8 arrays,
> so I don't see where union aliasing is happening here?

Okay, for now I can see only Thunderbolt user of these properties (is it
correct?) in upstream which uses u8 arrays indeed.

Though the implementation is quite fragile in this sense, because it
doesn't discourage people to use device_property_read_string() in case
when it's indeed a string (I saw these kind of properties in the very
dump you posted on your GH page).

So, I can agree that is "not happening _right_now_", but I can't agree
on the implementation robustness.

I can change a wording of the commit message and the FIXME, but _leave_
FIXME in place b/c of above.

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
