<template>

	<div class="daily-widget">

		<div class="info-box bg-light data-widget-box">
					
			<span class="info-box-icon elevation-1 bg-light box-icon-color" :style="{background: ticket.icon_color}">

				<i :class="ticket.icon_class"></i>
			</span>

			<div class="info-box-content">
					
				<span class="info-box-text text-wrap">{{ticket.key}}</span>
			</div>
		</div>
	</div>
</template>

<script>

	export default {
  		
  		props: {
			
			ticket: { type: Object,default: () => ({}) }
  		}
	};
</script>

<style scoped>

	.data-widget-box {
		transition: box-shadow 280ms cubic-bezier(.4,0,.2,1);
		background: #fff;
		color: rgba(0,0,0,.87);
		box-shadow: 0 2px 1px -1px rgba(0,0,0,.2), 0 1px 1px 0 rgba(0,0,0,.14), 0 1px 3px 0 rgba(0,0,0,.12);
	}
	.daily-widget > .data-widget-box:hover {
		box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2), 0 6px 20px 0 rgba(0, 0, 0, 0.19);
	}
	.info-box {
		min-height: 75px;
	}
	.info-box-without-icon {
		display: block;
		min-height: 75px;
		background: #FFFFFF;
		width: 100%;
		border-radius: 2px;
		margin-bottom: 15px;
	}
	.info-box-icon {
		color: #FFFFFF;
	}

	.info-box-content-without-icon {
		padding: 1rem;
	}

  .box-icon-color { color: #1f2d3db3 !important; }

	#dark-text { color: #343a40 !important; }

	.daily-widget { cursor: move; }
</style>
