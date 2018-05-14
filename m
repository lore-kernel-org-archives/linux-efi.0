From: Lukas Wunner <lukas@wunner.de>
Subject: Re: [PATCH v2] device property: Get rid of union aliasing
Date: Mon, 14 May 2018 14:18:17 +0200
Message-ID: <20180514121817.GA27869@wunner.de>
References: <20180508131547.44366-1-andriy.shevchenko@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180508131547.44366-1-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-efi@vger.kernel.org, Sakari Ailus <sakari.ailus@linux.intel.com>, Mika Westerberg <mika.westerberg@linux.intel.com>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, ACPI Devel Maling List <linux-acpi@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On Tue, May 08, 2018 at 04:15:47PM +0300, Andy Shevchenko wrote:
> --- a/drivers/firmware/efi/apple-properties.c
> +++ b/drivers/firmware/efi/apple-properties.c
> @@ -13,6 +13,9 @@
>   *
>   * You should have received a copy of the GNU General Public License
>   * along with this program; if not, see <http://www.gnu.org/licenses/>.
> + *
> + * FIXME: The approach is still based on union aliasing and should be
> + * replaced by a proper resource provider.

Why?  All Apple EFI properties are either boolean or u8 arrays.
You've correctly changed this file to always supply u8 arrays,
so I don't see where union aliasing is happening here?

Thanks,

Lukas

>   */
>  
>  #define pr_fmt(fmt) "apple-properties: " fmt
> @@ -96,12 +99,13 @@ static void __init unmarshal_key_value_pairs(struct dev_header *dev_header,
>  		entry[i].name = key;
>  		entry[i].length = val_len - sizeof(val_len);
>  		entry[i].is_array = !!entry[i].length;
> -		entry[i].pointer.raw_data = ptr + key_len + sizeof(val_len);
> +		entry[i].type = DEV_PROP_U8;
> +		entry[i].pointer.u8_data = ptr + key_len + sizeof(val_len);
>  
>  		if (dump_properties) {
>  			dev_info(dev, "property: %s\n", entry[i].name);
>  			print_hex_dump(KERN_INFO, pr_fmt(), DUMP_PREFIX_OFFSET,
> -				16, 1, entry[i].pointer.raw_data,
> +				16, 1, entry[i].pointer.u8_data,
>  				entry[i].length, true);
>  		}
>  
