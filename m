From: Robert Richter <robert.richter@caviumnetworks.com>
Subject: Re: [PATCH v14 2/6] Documentation, dt, numa: dt bindings for NUMA.
Date: Mon, 7 Mar 2016 20:22:20 +0100
Message-ID: <20160307192220.GA1535@rric.localdomain>
References: <1457049339-23351-1-git-send-email-ddaney.cavm@gmail.com>
 <1457049339-23351-3-git-send-email-ddaney.cavm@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <1457049339-23351-3-git-send-email-ddaney.cavm@gmail.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: David Daney <ddaney.cavm@gmail.com>
Cc: Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org, linux-efi@vger.kernel.org, David Daney <david.daney@cavium.com>, Pawel Moll <pawel.moll@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Matt Fleming <matt@codeblueprint.co.uk>, Catalin Marinas <catalin.marinas@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>, Grant Likely <grant.likely@linaro.org>, Ganapatrao Kulkarni <gkulkarni@caviumnetworks.com>, Frank Rowand <frowand.list@gmail.com>, linux-arm-kernel@lists.infradead.org
List-Id: linux-efi@vger.kernel.org

On 03.03.16 15:55:35, David Daney wrote:
> From: Ganapatrao Kulkarni <gkulkarni@caviumnetworks.com>
> 
> Add DT bindings for numa mapping of memory, CPUs and IOs.
> 
> Reviewed-by: Robert Richter <rrichter@cavium.com>
> Signed-off-by: Ganapatrao Kulkarni <gkulkarni@caviumnetworks.com>
> Signed-off-by: David Daney <david.daney@cavium.com>
> ---
>  Documentation/devicetree/bindings/numa.txt | 272 +++++++++++++++++++++++++++++
>  1 file changed, 272 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/numa.txt
> 
> diff --git a/Documentation/devicetree/bindings/numa.txt b/Documentation/devicetree/bindings/numa.txt
> new file mode 100644
> index 0000000..ec5ed7c
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/numa.txt

> +==============================================================================
> +3 - distance-map
> +==============================================================================
> +
> +The device tree node distance-map describes the relative
> +distance (memory latency) between all numa nodes.
> +
> +- compatible : Should at least contain "numa-distance-map-v1".
> +
> +- distance-matrix
> +  This property defines a matrix to describe the relative distances
> +  between all numa nodes.
> +  It is represented as a list of node pairs and their relative distance.
> +
> +  Note:
> +	1. Each entry represents distance from first node to second node.
> +	The distances are equal in either direction.
> +	2. The distance from a node to self (local distance) is represented
> +	with value 10 and all internode distance should be represented with
> +	a value greater than 10.
> +	3. distance-matrix should have entries in lexicographical ascending
> +	order of nodes.
> +	4. There must be only one device node distance-map which must reside in the root node.

There is no note that this one is optional, but is it right? The
default is 10 for local and 20 for remote connections.

If so, then ...

static int __init of_numa_parse_distance_map(void)
{
	int ret = -EINVAL;
	struct device_node *np = of_find_node_by_path("/distance-map");

	if (!np)
		return ret;

must return 0 instead of -EINVAL here.

-Robert

> +
> +Example:
> +	4 nodes connected in mesh/ring topology as below,
> +
> +		0_______20______1
> +		|               |
> +		|               |
> +		20             20
> +		|               |
> +		|               |
> +		|_______________|
> +		3       20      2
> +
> +	if relative distance for each hop is 20,
> +	then internode distance would be,
> +	      0 -> 1 = 20
> +	      1 -> 2 = 20
> +	      2 -> 3 = 20
> +	      3 -> 0 = 20
> +	      0 -> 2 = 40
> +	      1 -> 3 = 40
> +
> +     and dt presentation for this distance matrix is,
> +
> +		distance-map {
> +			 compatible = "numa-distance-map-v1";
> +			 distance-matrix = <0 0  10>,
> +					   <0 1  20>,
> +					   <0 2  40>,
> +					   <0 3  20>,
> +					   <1 0  20>,
> +					   <1 1  10>,
> +					   <1 2  20>,
> +					   <1 3  40>,
> +					   <2 0  40>,
> +					   <2 1  20>,
> +					   <2 2  10>,
> +					   <2 3  20>,
> +					   <3 0  20>,
> +					   <3 1  40>,
> +					   <3 2  20>,
> +					   <3 3  10>;
> +		};
