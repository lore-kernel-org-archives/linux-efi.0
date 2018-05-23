From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [PATCH v3] device property: Get rid of union aliasing
Date: Wed, 23 May 2018 13:33:00 +0200
Message-ID: <1613149.qu9zDKzsAX@aspire.rjw.lan>
References: <20180515173202.84296-1-andriy.shevchenko@linux.intel.com> <20180516094133.GN32438@lahna.fi.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180516094133.GN32438@lahna.fi.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mika Westerberg <mika.westerberg@linux.intel.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-efi@vger.kernel.org, Sakari Ailus <sakari.ailus@linux.intel.com>, ACPI Devel Maling List <linux-acpi@vger.kernel.org>, Lukas Wunner <lukas@wunner.de>
List-Id: linux-efi@vger.kernel.org

On Wednesday, May 16, 2018 11:41:33 AM CEST Mika Westerberg wrote:
> On Tue, May 15, 2018 at 08:32:02PM +0300, Andy Shevchenko wrote:
> > The commit
> > 
> >   318a19718261 ("device property: refactor built-in properties support")
> > 
> > went way too far and brought a union aliasing. Partially revert it here
> > to get rid of union aliasing.
> > 
> > Note, all Apple properties are considered as u8 arrays. To get a value
> > of any of them the caller must use device_property_read_u8_array().
> > 
> > What union aliasing is?
> > ~~~~~~~~~~~~~~~~~~~~~~~
> > The C99 standard in section 6.2.5 paragraph 20 defines union type as
> > "an overlapping nonempty set of member objects". It also states in
> > section 6.7.2.1 paragraph 14 that "the value of at most one of the
> > members can be stored in a union object at any time'.
> > 
> > Union aliasing is a type punning mechanism using union members to store
> > as one type and read back as another.
> > 
> > Why it's not good?
> > ~~~~~~~~~~~~~~~~~~
> > Section 6.2.6.1 paragraph 6 says that a union object may not be a trap
> > representation, although its member objects may be.
> > 
> > Meanwhile annex J.1 says that "the value of a union member other than
> > the last one stored into" is unspecified [removed in C11].
> > 
> > In TC3, a footnote is added which specifies that accessing a member of a
> > union other than the last one stored causes "the object representation"
> > to be re-interpreted in the new type and specifically refers to this as
> > "type punning". This conflicts to some degree with Annex J.1.
> > 
> > While it's working in Linux with GCC, the use of union members to do
> > type punning is not clear area in the C standard and might lead to
> > unspecified behaviour.
> > 
> > More information is available in this [1] blog post.
> > 
> > [1]: https://davmac.wordpress.com/2010/02/26/c99-revisited/
> > 
> > Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> 
> Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> --

Applied, thanks!
